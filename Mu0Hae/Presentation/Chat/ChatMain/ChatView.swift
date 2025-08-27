//
//  ChatView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct ChatView: View {
    @Environment(MainCoordinator.self) private var coordiinator
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.injected) private var injected: DIContainer
    
    init(viewModel: ChatViewModel? = nil) {
        if let viewModel = viewModel {
            self._viewModel = StateObject(wrappedValue: viewModel)
        } else {
            let tempContainer = DIContainer()
            self._viewModel = StateObject(wrappedValue: tempContainer.createViewModels().chatViewModel)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages ScrollView
                if viewModel.messages.isEmpty {
                    // 화면 정중앙에 환영 메시지
                    VStack {
                        Spacer()
                        Text("무조건 공감만 해드릴게요.\n대화를 시작해주세요.")
                            .muFont(.body1)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color("muSubText"))
                        Spacer()
                    }
                } else {
                    // 실제 메시지 표시
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.messages) { message in
                                MessageRowView(message: message)
                                    .padding(.horizontal, 8)
                            }
                            
                            // 로딩 상태일 때 LoadingMessageView 표시
                            if viewModel.isLoading {
                                LoadingMessageView(guestType: viewModel.selectedGuestType)
                                    .padding(.horizontal, 8)
                                    .padding(.top, 8)
                            }
                        }
                        .padding(.horizontal, 12)
                    }
                }
                
                // Fixed Input at Bottom
                ChatInputView(chatViewModel: viewModel)
            }
            .background(Color("muBackground"))
            .navigationBarTitleDisplayMode(.inline)
            .onTapGesture {
                hideKeyboard()
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Image("imgTitle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        coordiinator.push(.guestSelection)
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    ChatView()
        .inject(DIContainer())
}
