//
//  DefaultChatRepository.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

final class DefaultChatRepository: ChatRepository {
    private let chatService: ChatNetworkService
    
    init(chatService: ChatNetworkService = ChatNetworkService()) {
        self.chatService = chatService
    }
    
    func sendMessage(_ message: String, conversationId: String, guestType: GuestType) async throws -> ChatEntity {
        let requestDTO = ChatRequestDTO(
            message: message,
            guestCode: guestType.rawValue
        )
        
        let responseDTO = try await chatService.sendChatMessage(requestDTO)
        return responseDTO.toChatEntity(guestType: guestType)
    }
    
    func getMessages(for conversationId: String) async throws -> [ChatEntity] {
        // TODO: Implement if server supports message history
        return []
    }
}
