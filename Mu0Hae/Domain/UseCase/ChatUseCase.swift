//
//  ChatUseCase.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

protocol ChatUseCase {
    func sendMessage(_ message: String, conversationId: String, guestType: GuestType) async throws -> ChatEntity
    func getMessages(for conversationId: String) async throws -> [ChatEntity]
}

final class DefaultChatUseCase: ChatUseCase {
    private let chatRepository: ChatRepository
    
    init(chatRepository: ChatRepository) {
        self.chatRepository = chatRepository
    }
    
    func sendMessage(_ message: String, conversationId: String, guestType: GuestType) async throws -> ChatEntity {
        return try await chatRepository.sendMessage(message, conversationId: conversationId, guestType: guestType)
    }
    
    func getMessages(for conversationId: String) async throws -> [ChatEntity] {
        return try await chatRepository.getMessages(for: conversationId)
    }
}