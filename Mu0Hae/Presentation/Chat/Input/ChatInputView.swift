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
              
                TextField("마음 속 이야기를 적어주세요",
                          text: $viewModel.currentText,
                          axis: .vertical)
                .foregroundStyle(.muText)
                .muFont(.body1)
                .lineLimit(1...4)
                .focused($isTextFieldFocused)
                .accessibilityLabel("메시지 입력 필드")
                .accessibilityHint("메시지를 입력하거나 음성 녹음을 사용할 수 있습니다")
                .accessibilityValue(viewModel.currentText.isEmpty ? "비어있음" : viewModel.currentText)
                
                Button {
                    viewModel.toggleRecording()
                } label: {
                    Image(viewModel.isRecording ? .icMic : .icMic)
                        .renderingMode(.template)
                        .foregroundColor(.muPrimary)
                }
                .accessibilityLabel(viewModel.isRecording ? "녹음 중지" : "음성 녹음 시작")
                .accessibilityHint(viewModel.isRecording ? "탭하여 음성 녹음을 중지합니다" : "탭하여 음성으로 메시지를 입력할 수 있습니다")
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 11)
            .background(Color.muTextField)
            .cornerRadius(14)
            
            // Send Button (top aligned)
            Button {
                viewModel.sendMessage()
                isTextFieldFocused = false
            } label: {
                if viewModel.isSending {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(.white)
                        .frame(width: 44, height: 44)
                        .background(.muPrimary)
                        .clipShape(Circle())
                } else {
                    RoundedRectangle(cornerRadius: 14)
                        .frame(width: 42, height: 42)
                        .foregroundStyle(viewModel.isValidText ? .muPrimary : .muPlaceHolder)
                        .overlay {
                            Image(.icSend)
                                .renderingMode(.template)
                                .foregroundStyle(.muBackground)
                        }
                }
            }
            .disabled(!viewModel.isValidText || viewModel.isSending)
            .accessibilityLabel(viewModel.isSending ? "메시지 전송 중" : "메시지 전송")
            .accessibilityHint(viewModel.isSending ? "메시지가 전송 중입니다" : 
                               viewModel.isValidText ? "탭하여 메시지를 전송합니다" : "메시지를 입력하면 전송할 수 있습니다")
            .accessibilityAddTraits(viewModel.isSending ? [] : .isButton)
            .padding(4)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 18)
        .background(
            Color.muBackground
                .clipShape(
                    .rect(
                        topLeadingRadius: 15,
                        bottomLeadingRadius: 0,
                        bottomTrailingRadius: 0,
                        topTrailingRadius: 15
                    )
                )
                .background(Color.muLightGray) // 이 부분이 뒤로 나올 배경
        )
        .shadow(
            color: Color.black.opacity(0.05),
            radius: 15,
            x: 0,
            y: -2
        )
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
