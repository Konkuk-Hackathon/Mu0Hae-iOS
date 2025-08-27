//
//  DefaultChatHistoryRepository.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

final class DefaultChatHistoryRepository: ChatHistoryRepository {
    private let chatHistoryService: ChatHistoryNetworkServiceProtocol
    
    init(chatHistoryService: ChatHistoryNetworkServiceProtocol = ChatHistoryNetworkService()) {
        self.chatHistoryService = chatHistoryService
    }
    
    func getChatHistory() async throws -> [ThreadEntity] {
        let response = try await chatHistoryService.getChatHistory()
        return response.threadsOfMember.map { threadDTO in
            let messages = threadDTO.chats.map { chatDTO in
                let isCurrentUser = chatDTO.type == "USER"
                let guestType = GuestType(rawValue: chatDTO.guestCode) ?? .ubyung
                
                let user = MessageUser(
                    name: isCurrentUser ? "User" : guestType.displayName,
                    isCurrentUser: isCurrentUser,
                    guestType: isCurrentUser ? nil : guestType
                )
                
                return ChatEntity(
                    user: user,
                    text: chatDTO.content,
                    createdAt: ISO8601DateFormatter().date(from: chatDTO.timeStamp) ?? Date()
                )
            }
            
            return ThreadEntity(
                conversationId: threadDTO.conversationId,
                createdTime: ISO8601DateFormatter().date(from: threadDTO.createdTime) ?? Date(),
                messages: messages
            )
        }
    }
}