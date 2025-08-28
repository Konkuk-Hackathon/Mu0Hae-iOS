//
//  AudioPlayerManager.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation
import AVFAudio

@MainActor
final class AudioPlayerManager: NSObject {
    static let shared = AudioPlayerManager()
    
    private override init() {}
    
    private var audioPlayer: AVAudioPlayer?
    private var currentFileURL: URL?
    
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var isPlaying: Bool = false
    
    /// 오디오 파일을 불러와 재생
    func playAudio(from url: URL) async {
        stop()
        isLoading = true
        
        do {
            let data = try Data(contentsOf: url)
            currentFileURL = url
            
            audioPlayer = try AVAudioPlayer(data: data)
            audioPlayer?.delegate = self
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            isPlaying = true
        } catch {
            print("Audio play error:", error)
            isPlaying = false
        }
        
        isLoading = false
    }
    
    /// 재생 중지
    func stop() {
        audioPlayer?.stop()
        audioPlayer = nil
        isPlaying = false
    }
    
    private func deleteCurrentFile() {
        guard let url = currentFileURL else { return }
        do {
            try FileManager.default.removeItem(at: url)
            print("🗑️ Deleted audio file:", url.lastPathComponent)
        } catch {
            print("⚠️ Failed to delete file:", error)
        }
        currentFileURL = nil
    }
}

extension AudioPlayerManager: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        Task { @MainActor in
            self.isPlaying = false
            self.deleteCurrentFile()
        }
    }
}
