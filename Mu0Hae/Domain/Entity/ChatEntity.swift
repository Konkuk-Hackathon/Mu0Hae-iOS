//
//  ChatEntity.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI
import Speech

public struct ChatEntity: Identifiable, Hashable, Sendable {
    public let id: String
    public let user: MessageUser
    public let text: String
    public let createdAt: Date
    
    public init(id: String = UUID().uuidString,
                user: MessageUser,
                text: String,
                createdAt: Date = Date()) {
        self.id = id
        self.user = user
        self.text = text
        self.createdAt = createdAt
    }
}

public enum GuestType: String, Hashable, Sendable {
    case ubyung = "ubyung"
    case key = "key"
    
    var displayName: String {
        switch self {
        case .ubyung: return "유병재"
        case .key: return "키"
        }
    }
    
    var image: Image {
        switch self {
        case .ubyung: Image(.ybj)
        case .key: Image(.key)
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
