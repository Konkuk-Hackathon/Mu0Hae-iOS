//
//  ChatViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    @Published var messages: [ChatEntity] = []
    @Published var currentText: String = ""
    @Published var selectedGuestType: GuestType = .ubyung
    @Published var isLoading: Bool = false
    @Published var isLoadingHistory: Bool = false
    @Published var errorMessage: String?
    @Published var hasLoadedHistory: Bool = false
    
    private var conversationId: String
    private let currentUser: MessageUser
    private let chatUseCase: ChatUseCase
    private var cancellables = Set<AnyCancellable>()
    
    private let userDefaultsService = UserDefaultsService()
    
    init(chatUseCase: ChatUseCase, conversationId: String = "") {
        self.chatUseCase = chatUseCase
        self.conversationId = conversationId
        self.currentUser = MessageUser(
            name: "나",
            isCurrentUser: true
        )
    }
    
    // MARK: - Message Actions
    func sendMessage(_ messageText: String) -> AnyPublisher<Void, Error> {
        let userMessage = ChatEntity(
            user: currentUser,
            text: messageText
        )
        
        messages.append(userMessage)
        
        return Future { promise in
            Task {
                await self.sendMessageToServer(messageText, completion: promise)
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func sendMessageToServer(_ message: String, completion: @escaping (Result<Void, Error>) -> Void) async {
        isLoading = true
        errorMessage = nil
        
        do {
            let aiMessage = try await chatUseCase.sendMessage(
                message,
                conversationId: conversationId,
                guestType: selectedGuestType
            )
            
            await MainActor.run {
                self.messages.append(aiMessage)
                self.isLoading = false
                completion(.success(()))
            }
        } catch {
            await MainActor.run {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
                completion(.failure(error))
            }
        }
    }
    
    // MARK: - Chat History
    func loadChatHistoryOnce(container: DIContainer) {
        guard !hasLoadedHistory else { return }
        hasLoadedHistory = true
        isLoadingHistory = true
        
        Task {
            do {
                let threads = try await container.useCases.chatHistory.getChatHistory()
                
                // 모든 스레드의 모든 메시지들을 시간순으로 합쳐서 로드
                var allMessages: [ChatEntity] = []
                
                for thread in threads {
                    allMessages.append(contentsOf: thread.messages)
                }
                
                // 시간순으로 정렬 (오래된 것부터)
                allMessages.sort { $0.createdAt < $1.createdAt }
                
                await MainActor.run {
                    self.messages = allMessages
                    self.conversationId = threads.first?.conversationId ?? "default"
                    self.isLoadingHistory = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = "채팅 기록을 불러올 수 없습니다: \(error.localizedDescription)"
                    self.isLoadingHistory = false
                }
            }
        }
    }
    
    // MARK: - UI Helper Methods
    func shouldShowDateBadge(for message: ChatEntity, at index: Int) -> Bool {
        // 첫 번째 메시지는 항상 날짜 배지 표시
        guard index > 0 else { return true }
        
        let currentDate = Calendar.current.startOfDay(for: message.createdAt)
        let previousDate = Calendar.current.startOfDay(for: messages[index - 1].createdAt)
        
        // 이전 메시지와 다른 날짜인 경우 배지 표시
        return !Calendar.current.isDate(currentDate, inSameDayAs: previousDate)
    }
    
    func shouldShowGuestChange(for message: ChatEntity, at index: Int) -> (from: GuestType?, to: GuestType)? {
        // AI 메시지가 아니면 게스트 변경 없음
        guard !message.user.isCurrentUser, let currentGuest = message.user.guestType else { return nil }
        
        // 이전 AI 메시지의 게스트 타입 찾기
        var previousAIGuest: GuestType? = nil
        for i in (0..<index).reversed() {
            let prevMessage = messages[i]
            if !prevMessage.user.isCurrentUser, let guestType = prevMessage.user.guestType {
                previousAIGuest = guestType
                break
            }
        }
        
        // 이전 AI 게스트와 다른 경우에만 변경 알림 표시
        if let prevGuest = previousAIGuest, prevGuest != currentGuest {
            return (from: prevGuest, to: currentGuest)
        }
        
        return nil
    }
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
    
    func loadCurrentGuest() {
        switch userDefaultsService.load(type: String.self, key: .currentGuest) {
        case .success(let guest):
            if let guestType = GuestType(rawValue: guest) {
                selectedGuestType = guestType
                print("📥 저장된 채팅 상대 불러오기:", guestType)
            } else {
                print("❌ 저장된 값과 매칭되는 GuestType 없음:", guest)
            }
        case .failure(let error):
            print("❌ 불러오기 실패:", error)
        }
    }
}

