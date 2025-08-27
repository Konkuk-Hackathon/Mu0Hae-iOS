//
//  ChatHistoryResponseDTO.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

// MARK: - ChatHistoryResponse DTO
struct ChatHistoryResponseDTO: Codable {
    let threadsOfMember: [ThreadDTO]
}

struct ThreadDTO: Codable {
    let conversationId: String
    let createdTime: String
    let chats: [ChatDTO]
}

struct ChatDTO: Codable {
    let content: String
    let type: String
    let guestCode: String
    let timeStamp: String
}
