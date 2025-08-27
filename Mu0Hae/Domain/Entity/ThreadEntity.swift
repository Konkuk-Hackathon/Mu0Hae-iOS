//
//  ThreadEntity.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

struct ThreadEntity: Identifiable, Hashable, Sendable {
    let id = UUID()
    let conversationId: String
    let createdTime: Date
    let messages: [ChatEntity]
}
