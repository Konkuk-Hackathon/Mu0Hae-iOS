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
                
                Button {
                    viewModel.toggleRecording()
                } label: {
                    Image(viewModel.isRecording ? .icMic : .icMic)
                        .renderingMode(.template)
                        .foregroundColor(.muPrimary)
                }
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
            .padding(4)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 18)
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
