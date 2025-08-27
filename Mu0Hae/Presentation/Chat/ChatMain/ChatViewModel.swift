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
    @Published var errorMessage: String?
    
    private var conversationId: String
    private let currentUser: MessageUser
    private let chatUseCase: ChatUseCase
    private var cancellables = Set<AnyCancellable>()
    
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
    
    // MARK: - Error Handling
    func clearError() {
        errorMessage = nil
    }
}

