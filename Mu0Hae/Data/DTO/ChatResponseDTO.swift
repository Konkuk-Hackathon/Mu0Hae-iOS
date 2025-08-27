//
//  ChatDTO.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

// MARK: - Response DTOs
struct ChatResponseDTO: Codable {
    let response: String
    let timeStamp: String?
    
    init(response: String, timeStamp: String? = nil) {
        self.response = response
        self.timeStamp = timeStamp
    }
    
    func toChatEntity(guestType: GuestType) -> ChatEntity {
        let aiUser = MessageUser(
            name: guestType.displayName,
            isCurrentUser: false,
            guestType: guestType
        )
        
        let createdAt = timeStamp?.toDate() ?? Date()
        
        return ChatEntity(
            user: aiUser,
            text: response,
            createdAt: createdAt
        )
    }
}
