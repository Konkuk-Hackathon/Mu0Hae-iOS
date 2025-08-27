//
//  ChatRequestDTO.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/26/25.
//

import Foundation

// MARK: - Request DTOs
struct ChatRequestDTO: Codable {
    let message: String
    let guestCode: String
    
    init(message: String, guestCode: String) {
        self.message = message
        self.guestCode = guestCode
    }
    
    init(from chatEntity: ChatEntity, guestType: GuestType) {
        self.message = chatEntity.text
        self.guestCode = guestType.rawValue
    }
}
