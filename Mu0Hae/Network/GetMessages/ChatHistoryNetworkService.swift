//
//  ChatHistoryNetworkService.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import Foundation

protocol ChatHistoryNetworkServiceProtocol {
    func getChatHistory() async throws -> ChatHistoryResponseDTO
}

final class ChatHistoryNetworkService: ChatHistoryNetworkServiceProtocol {
    private let session: URLSession
    private let baseURL = "https://gllo-server.shop"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getChatHistory() async throws -> ChatHistoryResponseDTO {
        guard let url = URL(string: "\(baseURL)/api/chats") else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "accept")
        
        Logger.log(message: "🌐 GET Request to: \(url)")
        
        do {
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            Logger.log(message: "📡 Response Status: \(httpResponse.statusCode)")
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            let chatHistory = try decoder.decode(ChatHistoryResponseDTO.self, from: data)
            
            Logger.log(message: "✅ Successfully decoded chat history with \(chatHistory.threadsOfMember.count) threads")
            
            return chatHistory
            
        } catch let decodingError as DecodingError {
            Logger.log(message: "❌ Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            Logger.log(message: "❌ Network error: \(error)")
            throw NetworkError.networkError(error)
        }
    }
}
