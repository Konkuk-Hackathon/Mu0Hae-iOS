//
//  NetworkService.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

class ChatNetworkService {
    private let baseURL = "https://gllo-server.shop"
    private let session = URLSession.shared
    
    func sendChatMessage(_ request: ChatRequestDTO) async throws -> ChatResponseDTO {
        guard let url = URL(string: "\(baseURL)/api/chats") else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            
            // 요청 데이터 로그 출력
            if let requestString = String(data: jsonData, encoding: .utf8) {
                Logger.log(message: "📤 API Request: \(requestString)")
            }
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                // 서버 에러 응답도 로그로 출력
                if let errorString = String(data: data, encoding: .utf8) {
                    Logger.log(message: "❌ Server Error Response: \(errorString)")
                }
                throw NetworkError.serverError(httpResponse.statusCode)
            }
            
            // 응답 데이터를 로그로 출력
            if let responseString = String(data: data, encoding: .utf8) {
                Logger.log(message: "📤 API Response: \(responseString)")
            }
            
            let responseDTO = try JSONDecoder().decode(ChatResponseDTO.self, from: data)
            return responseDTO
            
        } catch {
            if error is DecodingError {
                throw NetworkError.decodingError
            } else if error is EncodingError {
                throw NetworkError.encodingError
            } else {
                throw NetworkError.networkError(error)
            }
        }
    }
}


