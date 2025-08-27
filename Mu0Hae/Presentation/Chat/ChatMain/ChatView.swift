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
                ChatNavigationBarView()
                Group {
                    if viewModel.isLoadingHistory {
                        // 채팅 기록 로딩 중
                        VStack {
                            Spacer()
                            
                            ProgressView("채팅 기록을 불러오는 중...")
                                .muFont(.body2)
                                .foregroundStyle(.muSubText)
                            
                            Spacer()
                        }
                    } else if viewModel.messages.isEmpty {
                        VStack {
                            Spacer()
                            Text("무조건 공감만 해드릴게요.\n대화를 시작해주세요.")
                                .muFont(.body1)
                                .multilineTextAlignment(.center)
                                .foregroundStyle(.muSubText)
                            Spacer()
                        }
                    } else {
                        // 실제 메시지 표시
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(viewModel.messages) { message in
                                    MessageRowView(message: message)
                                }
                                
                                // 로딩 상태일 때 빈 메시지로 AIMessageView 표시
                                if viewModel.isLoading {
                                    let loadingUser = MessageUser(name: viewModel.selectedGuestType.displayName, isCurrentUser: false, guestType: viewModel.selectedGuestType)
                                    let loadingMessage = ChatEntity(user: loadingUser, text: "")
                                    MessageRowView(message: loadingMessage)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                            .padding(.vertical, 20)
                        }
                        .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                        .scrollIndicators(.hidden)
                        .padding(.horizontal, 20)
                    }
                }
                
                ChatInputView(chatViewModel: viewModel)
            }
            .background(Color.muBackground)
            .onTapGesture {
                hideKeyboard()
            }
            .onAppear {
                viewModel.loadChatHistoryOnce(container: injected)
            }
        }
    }
    
    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

private struct ChatNavigationBarView: View {
    @Environment(MainCoordinator.self) private var coordiinator
    
    var body: some View {
        HStack(spacing: 0) {
            Image(.imgTitle)
                .resizable()
                .scaledToFit()
                .frame(width: 78)
            
            Spacer()
            
            Image(.icHamburger)
                .renderingMode(.template)
                .foregroundStyle(.muText)
                .onTapGesture {
                    coordiinator.push(.guestSelection)
                }
        }
        .frame(height: 56)
        .padding(.horizontal, 20)
        .background(Color.muBackground)
    }
}

#Preview {
    let container = DIContainer()
    ChatView()
        .inject(container)
        .environment(MainCoordinator())
}
