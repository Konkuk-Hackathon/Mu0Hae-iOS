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
    case baekhyun = "back"
    case jaesuk = "you"
    
    var displayName: String {
        switch self {
        case .ubyung: return "유병재"
        case .key: return "키"
        case .baekhyun: return "백현"
        case .jaesuk: return "유재석"
        }
    }
    
    var image: Image {
        switch self {
        case .ubyung: Image(.ybj)
        case .key: Image(.key)
        case .baekhyun: Image(.baekhyun)
        case .jaesuk: Image(.jaesuk)
        }
    }
    
    var description: String {
        switch self {
        case .ubyung: return "어떤 사연이든, 무엇이든 다 공감해드립니다."
        case .key: return "샤이니 T 아니고 키에요. 믿고 맡겨주세요."
        case .baekhyun: return "감미로운 목소리로 당신의 이야기에 귀 기울여줄게요."
        case .jaesuk: return "국민MC로서 유퀴즈에 온 것 같은 공감능력을 보여드릴게요."
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
