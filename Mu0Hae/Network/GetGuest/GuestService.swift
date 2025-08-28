//
//  GuestService.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import SwiftUI

protocol GuestServiceProtocol {
    func getGuestList() async throws -> GuestListDTO
}

final class GuestService: GuestServiceProtocol {
    private let session: URLSession
    let baseURL = "https://0a268486d693.ngrok-free.app"
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func getGuestList() async throws -> GuestListDTO {
        guard let url = URL(string: "\(baseURL)/speakers/sft") else {
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
            let guestList = try decoder.decode(GuestListDTO.self, from: data)
            
            Logger.log(message: "✅ Successfully decoded chat history with \(guestList)")
            
            return guestList
            
        } catch let decodingError as DecodingError {
            Logger.log(message: "❌ Decoding error: \(decodingError)")
            throw NetworkError.decodingError
        } catch {
            Logger.log(message: "❌ Network error: \(error)")
            throw NetworkError.networkError(error)
        }
    }
}
