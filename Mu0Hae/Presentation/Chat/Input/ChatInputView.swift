//
//  ChatInputView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import Combine
import SwiftUI

struct ChatInputView: View {
    @StateObject private var viewModel = ChatInputViewModel()
    @FocusState private var isTextFieldFocused: Bool
    @Environment(\.injected) private var injected: DIContainer
    
    let chatViewModel: ChatViewModel
    @State private var cancellables = Set<AnyCancellable>()
    
    init(chatViewModel: ChatViewModel) {
        self.chatViewModel = chatViewModel
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // Text Input Field
            HStack(alignment: .center, spacing: 8) {
                TextField("내용을 입력하세요.", text: $viewModel.currentText, axis: .vertical)
                    .muFont(.body1)
                    .lineLimit(1...4)
                    .focused($isTextFieldFocused)
                
                Button(action: {
                    viewModel.toggleRecording()
                }) {
                    Image("icMic")
                        .foregroundColor(viewModel.isRecording ? .muPrimary : .muBackground)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.muTextField)
            .cornerRadius(22)
            
            // Send Button (top aligned)
            Button(action: {
                viewModel.sendMessage()
                isTextFieldFocused = false
            }) {
                if viewModel.isSending {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.green)
                        .clipShape(Circle())
                } else {
                    Image("icSend")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color.muBackground)
                        .frame(width: 44, height: 44)
                        .background(viewModel.isValidText ? .muPrimary : .muPlaceHolder)
                        .clipShape(Circle())
                }
            }
            .disabled(!viewModel.isValidText || viewModel.isSending)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(.systemBackground))
        .onAppear {
            setupBindings()
        }
    }
    
    private func setupBindings() {
        viewModel.sendMessagePublisher
            .flatMap { message -> AnyPublisher<Void, Never> in
                self.chatViewModel.sendMessage(message)
                    .catch { error -> AnyPublisher<Void, Never> in
                        Logger.log(message: "Failed to send message: \(error)")
                        return Empty<Void, Never>().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            }
            .sink { _ in
                // Message sent successfully
            }
            .store(in: &cancellables)
    }
}

#Preview {
    let container = DIContainer()
    let chatViewModel = ChatViewModel(chatUseCase: container.useCases.chat)
    
    ChatInputView(chatViewModel: chatViewModel)
        .inject(container)
}
