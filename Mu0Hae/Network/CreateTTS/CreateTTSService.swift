//
//  CreateTTSService.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation
import AVFAudio

class CreateTTSService {
    private let baseURL = "https://0a268486d693.ngrok-free.app/tts"
    private let session = URLSession.shared
    
    func requestTTS(text: String,
                    speakerId: String,
                    speed: Double = 1.0) async throws -> Data {
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
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
        }
        
        if httpResponse.statusCode == 200 {
            return data
        } else {
            let errorString = String(data: data, encoding: .utf8) ?? "알 수 없는 오류"
            throw NSError(domain: "TTS API", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: errorString])
        }
    }
}

@MainActor
final class TTSViewModel: NSObject, ObservableObject {
    @Published var isLoading = false
    @Published var audioPlayer: AVAudioPlayer?
    
    private let service = CreateTTSService()
    private var currentFileURL: URL?
    
    func fetchAndPlay(text: String, speakerId: String) async {
        guard !isLoading else { return }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let wavData = try await service.requestTTS(text: text, speakerId: speakerId)
            
            // 기존 오디오가 재생 중이면 중단
            if audioPlayer?.isPlaying == true {
                audioPlayer?.stop()
            }
            
            // 저장
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("tts.wav")
            try wavData.write(to: fileURL)
            currentFileURL = fileURL
            
            // wav 파일 확인
            if FileManager.default.fileExists(atPath: fileURL.path) {
                print("🎵 wav 파일 생성 성공: \(fileURL.path)")
            } else {
                print("❌ wav 파일이 존재하지 않습니다")
            }
            
            // 재생
            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌ TTS 실패:", error.localizedDescription)
        }
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
