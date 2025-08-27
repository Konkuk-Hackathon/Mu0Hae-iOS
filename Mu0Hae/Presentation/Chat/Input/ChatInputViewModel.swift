//
//  ChatInputViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Foundation
import Combine

@MainActor
final class ChatInputViewModel: ObservableObject {
    @Published var currentText: String = ""
    @Published var isSending: Bool = false
    
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
}

