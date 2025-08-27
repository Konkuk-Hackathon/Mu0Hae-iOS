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
                    .accessibilityLabel("메시지 입력 필드")
                    .accessibilityHint("메시지를 입력하거나 음성 녹음을 사용할 수 있습니다")
                    .accessibilityValue(viewModel.currentText.isEmpty ? "비어있음" : viewModel.currentText)
                
                Button(action: {
                    viewModel.toggleRecording()
                }) {
                    Image(viewModel.isRecording ? "icMic" : "icMic_filled")
                        .resizable()
                        .frame(width: 28, height: 28)
                        .foregroundColor(viewModel.isRecording ? .muPrimary : .muBackground)
                }
                .accessibilityLabel(viewModel.isRecording ? "녹음 중지" : "음성 녹음 시작")
                .accessibilityHint(viewModel.isRecording ? "탭하여 음성 녹음을 중지합니다" : "탭하여 음성으로 메시지를 입력할 수 있습니다")
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
            .accessibilityLabel(viewModel.isSending ? "메시지 전송 중" : "메시지 전송")
            .accessibilityHint(viewModel.isSending ? "메시지가 전송 중입니다" : 
                               viewModel.isValidText ? "탭하여 메시지를 전송합니다" : "메시지를 입력하면 전송할 수 있습니다")
            .accessibilityAddTraits(viewModel.isSending ? [] : .isButton)
            .padding(4)
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
