//
//  ChatEntity.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation
import Speech

public struct ChatEntity: Identifiable, Hashable, Sendable {
    public let id: String
    public let conversationId: String
    public let user: MessageUser
    public let text: String
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString,
                conversationId: String,
                user: MessageUser,
                text: String,
                createdAt: Date = Date()) {
        self.id = id
        self.conversationId = conversationId
        self.user = user
        self.text = text
        self.createdAt = createdAt
    }
}

public enum GuestType: String, Hashable, Sendable {
    case ybj = "ybj"
    case key = "key"
    
    var displayName: String {
        switch self {
        case .ybj: return "유병재"
        case .key: return "키"
        }
    }
}

public struct MessageUser: Identifiable, Hashable, Sendable {
    public let id: String
    public let name: String
    public let isCurrentUser: Bool
    public let guestType: GuestType?
    
    public init(id: String = UUID().uuidString,
                name: String,
                isCurrentUser: Bool,
                guestType: GuestType? = nil) {
        self.id = id
        self.name = name
        self.isCurrentUser = isCurrentUser
        self.guestType = guestType
    }
}
