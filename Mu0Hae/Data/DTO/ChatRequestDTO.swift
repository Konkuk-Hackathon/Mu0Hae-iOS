//
//  ChatRequestDTO.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/26/25.
//

import Foundation

// MARK: - Request DTOs
struct ChatRequestDTO: Codable {
    let conversationId: String // TODO: 추후 삭제될 속성
    let message: String
    let guestCode: String
    
    init(conversationId: String, message: String, guestCode: String) {
        self.conversationId = conversationId
        self.message = message
        self.guestCode = guestCode
    }
    
    init(from chatEntity: ChatEntity, guestType: GuestType) {
        self.conversationId = chatEntity.conversationId
        self.message = chatEntity.text
        self.guestCode = guestType.rawValue
    }
}
