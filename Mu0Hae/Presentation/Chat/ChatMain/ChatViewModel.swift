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
    @Published var selectedGuestType: GuestType = .ybj
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let conversationId: String
    private let currentUser: MessageUser
    private let chatUseCase: ChatUseCase
    private var cancellables = Set<AnyCancellable>()
    
    init(chatUseCase: ChatUseCase, conversationId: String = UUID().uuidString) {
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
            conversationId: conversationId,
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
        
        // MARK: - 더미 서버 응답 (실제 서버 연결 전)
        // TODO: 실제 서버 연동시 아래 더미 코드를 주석 처리하고 실제 API 호출로 대체
        do {
            // 1-2초 딜레이로 서버 응답 시뮬레이션
            try await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000_000...2_000_000_000))
            
            // 선택된 게스트에 따른 더미 응답 생성
            let dummyResponse = generateDummyResponse(for: selectedGuestType, userMessage: message)
            
            let aiUser = MessageUser(
                name: selectedGuestType.displayName,
                isCurrentUser: false,
                guestType: selectedGuestType
            )
            
            let aiMessage = ChatEntity(
                conversationId: conversationId,
                user: aiUser,
                text: dummyResponse
            )
            
            await MainActor.run {
                self.messages.append(aiMessage)
                self.isLoading = false
                completion(.success(()))
            }
        } catch {
            await MainActor.run {
                self.errorMessage = "더미 응답 생성 실패: \(error.localizedDescription)"
                self.isLoading = false
                completion(.failure(error))
            }
        }
        
        /* 실제 서버 API 호출 코드 (현재 주석 처리)
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
        */
    }
    
    // MARK: - 더미 응답 생성 (테스트용)
    private func generateDummyResponse(for guestType: GuestType, userMessage: String) -> String {
        let responses: [GuestType: [String]] = [
            .ybj: [
                "아, 진짜 힘드시구나. 그런 말씀만 들어도 나도 가슴이 아파요.",
                "와, 정말 안스럽다. 그런 상황이면 누구라도 힘들 거예요.",
                "이해해요. 그런 기분 정말 답답하고 속상하실 거 같아요.",
                "맞아요, 그런 일 겪으면 진짜 힘들죠. 많이 지치셨을 것 같아요.",
                "진심으로 공감해요. 그런 상황에서는 누구나 그럴 수밖에 없어요."
            ],
            .key: [
                "아니 요즘 세상에 무슨 일이 이렇게 많아? 진짜 진짜 안 써요.",
                "어떻게 그런 일이 있을 수가 있지? 정말 말도 안 되는 상황이네요.",
                "이거 진짜 말이 안 되는 거 아니야? 너무 힘들어 보이는데.",
                "와, 이런 일도 있구나. 정말 예상치 못한 상황이네요.",
                "어머, 그런 일이 있었어요? 정말 놀랍고 당황스러우시겠어요."
            ]
        ]
        
        let guestResponses = responses[guestType] ?? ["죄송합니다. 응답을 생성할 수 없습니다."]
        return guestResponses.randomElement() ?? "기본 응답입니다."
    }
    
    // MARK: - Guest Selection
    func selectGuest(_ guestType: GuestType) {
        selectedGuestType = guestType
    }
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
}

