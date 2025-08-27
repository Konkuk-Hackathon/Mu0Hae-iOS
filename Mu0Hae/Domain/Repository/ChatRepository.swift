//
//  ChatRepository.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

protocol ChatRepository {
    func sendMessage(_ message: String, conversationId: String, guestType: GuestType) async throws -> ChatEntity
    func getMessages(for conversationId: String) async throws -> [ChatEntity]
}