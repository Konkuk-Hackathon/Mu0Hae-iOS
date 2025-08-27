//
//  RecordManager.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import AVFoundation
import Speech

protocol RecordManagerProtocol {
    var recognizedText: String { get }
    
    func setupSpeech() async throws
    func startRecording() throws
    func stopRecording()
    func resetAll()
}

final class DefaultRecordManager: RecordManagerProtocol {
    private let speechRecognizer: SFSpeechRecognizer
    private let audioEngine: AVAudioEngine
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    
    private(set) var recognizedText: String = ""
    
    init(locale: Locale = Locale(identifier: "ko-KR")) {
        self.speechRecognizer = SFSpeechRecognizer(locale: locale)!
        self.audioEngine = AVAudioEngine()
    }
    
    func setupSpeech() async throws {
        let speechStatus = await withCheckedContinuation { continuation in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        
        let micStatus = await AVCaptureDevice.requestAccess(for: .audio)
        let micAuthStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        switch (speechStatus, micStatus, micAuthStatus) {
        case (.authorized, true, _):
            return
        case (.notDetermined, _, _), (_, _, .notDetermined):
            return
        default:
            throw RecordingError.permissionError
        }
    }
    
    func startRecording() throws {
        try setupNewRecording()
    }
    
    func stopRecording() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionTask?.cancel()
    }
    
    func resetAll() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        
        recognitionTask?.cancel()
        recognitionTask = nil
        
        recognizedText = ""
    }
    
    private func setupNewRecording() throws {
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.playAndRecord,
                                       mode: .default,
                                       options: [.defaultToSpeaker, .allowBluetooth])
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            
            recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            
            guard let recognitionRequest = recognitionRequest else {
                throw RecordingError.audioError
            }
            
            recognitionRequest.shouldReportPartialResults = true
            
            let inputNode = audioEngine.inputNode
            let recordingFormat = inputNode.outputFormat(forBus: 0)
            
            inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
                self?.recognitionRequest?.append(buffer)
            }
            
            audioEngine.prepare()
            try audioEngine.start()
            
            recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
                guard let self = self else { return }
                
                if let result = result {
                    self.recognizedText = result.bestTranscription.formattedString
                }
                
                if error != nil {
                    self.stopRecording()
                }
            }
        } catch {
            throw RecordingError.audioError
        }
    }
}
