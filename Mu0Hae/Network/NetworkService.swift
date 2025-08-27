//
//  NetworkService.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation

class ChatNetworkService {
    private let baseURL = "https://your-api-base-url.com" // TODO: url 교체
    private let session = URLSession.shared
    
    func sendChatMessage(_ request: ChatRequestDTO) async throws -> ChatResponseDTO {
        guard let url = URL(string: "\(baseURL)/chat") else {
            throw NetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(request)
            urlRequest.httpBody = jsonData
            
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.invalidResponse
            }
            
            guard 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.serverError(httpResponse.statusCode)
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


