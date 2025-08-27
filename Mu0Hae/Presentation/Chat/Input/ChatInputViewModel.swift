//
//  ChatInputViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation
import Combine
import AudioToolbox

@MainActor
final class ChatInputViewModel: ObservableObject {
    @Published var currentText: String = ""
    @Published var isSending: Bool = false
    @Published var isRecording: Bool = false
    
    // Input validation
    var isValidText: Bool {
        !currentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    // Line count calculation
    var lineCount: Int {
        let lines = currentText.components(separatedBy: .newlines)
        return max(1, lines.count)
    }
    
    // Combine Subject for message sending
    private let sendMessageSubject = PassthroughSubject<String, Never>()
    
    
    // MARK: - Actions
    func sendMessage() {
        guard isValidText, !isSending else { return }
        
        let messageToSend = currentText
        currentText = ""
        
        sendMessageSubject.send(messageToSend)
    }
    
    // MARK: - Publishers
    var sendMessagePublisher: AnyPublisher<String, Never> {
        sendMessageSubject.eraseToAnyPublisher()
    }
    
    func clearText() {
        currentText = ""
    }
    
    private var recordManager: RecordManagerProtocol?
    private var previousText: String = ""
    
    func toggleRecording() {
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }
    
    private func startRecording() {
        Task {
            do {
                if recordManager == nil {
                    recordManager = DefaultRecordManager()
                    try await recordManager?.setupSpeech()
                }
                
                previousText = currentText
                
                try recordManager?.startRecording()
                isRecording = true
                playRecordingStartSound()
                startObservingText()
            } catch {
                Logger.log(message: "Failed to start recording: \(error)")
                isRecording = false
            }
        }
    }
    
    private func stopRecording() {
        recordManager?.stopRecording()
        isRecording = false
        playRecordingStopSound()
        
        let recognizedText = recordManager?.recognizedText ?? ""
        if !recognizedText.isEmpty {
            if previousText.isEmpty {
                currentText = recognizedText
            } else {
                currentText = previousText + " " + recognizedText
            }
        }
        
        recordManager?.resetAll()
        recordManager = nil
    }
    
    private func startObservingText() {
        Task {
            while isRecording {
                let recognizedText = recordManager?.recognizedText ?? ""
                if !recognizedText.isEmpty {
                    if previousText.isEmpty {
                        currentText = recognizedText
                    } else {
                        currentText = previousText + " " + recognizedText
                    }
                }
                try await Task.sleep(nanoseconds: 100_000_000)
            }
        }
    }
    
    // MARK: - Sound Effects
    private func playRecordingStartSound() {
        AudioServicesPlaySystemSound(1110) // Begin recording sound
    }
    
    private func playRecordingStopSound() {
        AudioServicesPlaySystemSound(1111) // End recording sound
    }
}

