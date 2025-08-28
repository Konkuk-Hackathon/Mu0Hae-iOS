//
//  CreateTTSService.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation
import AVFAudio

class CreateTTSService {
    static let shared = CreateTTSService()
    private init() {}
    
    private let baseURL = "https://0a268486d693.ngrok-free.app/tts"
    private let session = URLSession.shared
    private var currentDataTask: URLSessionDataTask?
    
    func requestTTS(text: String,
                    speakerId: String,
                    speed: Double = 1.0) async throws -> Data {
        
        // 이전 요청 취소
        currentDataTask?.cancel()
        
        var request = URLRequest(url: URL(string: baseURL)!)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        var body = Data()
        
        func appendFormField(name: String, value: String) {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(name)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        
        appendFormField(name: "mode", value: "zero_shot")
        appendFormField(name: "speaker_id", value: speakerId)
        appendFormField(name: "text", value: text)
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        request.httpBody = body
        
        return try await withCheckedThrowingContinuation { continuation in
            let dataTask = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
                defer { self?.currentDataTask = nil }
                
                if let error = error {
                    if (error as NSError).code == NSURLErrorCancelled {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        continuation.resume(throwing: error)
                    }
                    return
                }
                
                guard let data = data,
                      let httpResponse = response as? HTTPURLResponse else {
                    continuation.resume(throwing: URLError(.badServerResponse))
                    return
                }
                
                if httpResponse.statusCode == 200 {
                    continuation.resume(returning: data)
                } else {
                    let errorString = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
                    let error = NSError(domain: "TTS API", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString])
                    continuation.resume(throwing: error)
                }
            }
            
            self.currentDataTask = dataTask
            dataTask.resume()
        }
    }
}

@MainActor
final class TTSViewModel: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var audioPlayer: AVAudioPlayer?
    
    private let service = CreateTTSService.shared
    private var currentFileURL: URL?
    private var currentTask: Task<Void, Never>?
    
    static private var globalCurrentTask: Task<Void, Never>?
    
    func fetchAndPlay(text: String, speakerId: String) async {
        Self.globalCurrentTask?.cancel()
        
        let task = Task {
            do {
                isLoading = true
                defer {
                    isLoading = false
                }
                
                let wavData = try await service.requestTTS(text: text, speakerId: speakerId)
                
                guard !Task.isCancelled else {
                    print("🚫 TTS 작업이 취소됨")
                    return
                }

                let fileURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("tts_\(UUID().uuidString).wav")

                try wavData.write(to: fileURL)

                if FileManager.default.fileExists(atPath: fileURL.path) {
                    print("✅ wav 파일 저장 성공: \(fileURL.path)")
                    let size = (try? Data(contentsOf: fileURL).count) ?? 0
                } else {
                    print("❌ wav 파일 저장 실패")
                }

                guard !Task.isCancelled else {
                    try? FileManager.default.removeItem(at: fileURL)
                    print("🚫 TTS 작업이 취소됨 - 파일 삭제")
                    return
                }

                await AudioPlayerManager.shared.playAudio(from: fileURL)
            } catch {
                if error is CancellationError {
                    print("🚫 TTS 작업이 취소됨")
                } else {
                    print("❌ TTS 실패:", error.localizedDescription)
                }
            }
        }
        
        Self.globalCurrentTask = task
        currentTask = task
        await task.value
    }

    
}

extension TTSViewModel: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            guard let fileURL = currentFileURL else { return }
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("✅ WAV 파일 삭제 완료:", fileURL)
            } catch {
                print("❌ WAV 파일 삭제 실패:", error)
            }
        }
    }
}
