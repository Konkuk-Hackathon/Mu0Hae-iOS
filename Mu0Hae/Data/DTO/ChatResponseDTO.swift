//
//  ChatDTO.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

// MARK: - Response DTOs
struct ChatResponseDTO: Codable {
    let message: String
    let timestamp: String?
    let conversationId: String?
    
    init(message: String, timestamp: String? = nil, conversationId: String? = nil) {
        self.message = message
        self.timestamp = timestamp
        self.conversationId = conversationId
    }
    
    func toChatEntity(guestType: GuestType) -> ChatEntity {
        let aiUser = MessageUser(
            name: guestType.displayName,
            isCurrentUser: false,
            guestType: guestType
        )
        
        let createdAt = timestamp?.toDate() ?? Date()
        
        return ChatEntity(
            conversationId: conversationId ?? "",
            user: aiUser,
            text: message,
            createdAt: createdAt
        )
    }
}
