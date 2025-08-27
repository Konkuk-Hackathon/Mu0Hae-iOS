//
//  ChatHistoryUseCase.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

protocol ChatHistoryUseCase {
    func getChatHistory() async throws -> [ThreadEntity]
}

final class DefaultChatHistoryUseCase: ChatHistoryUseCase {
    private let repository: ChatHistoryRepository
    
    init(repository: ChatHistoryRepository) {
        self.repository = repository
    }
    
    func getChatHistory() async throws -> [ThreadEntity] {
        return try await repository.getChatHistory()
    }
}