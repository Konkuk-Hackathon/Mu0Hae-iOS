//
//  ChatHistoryRepository.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

protocol ChatHistoryRepository {
    func getChatHistory() async throws -> [ThreadEntity]
}