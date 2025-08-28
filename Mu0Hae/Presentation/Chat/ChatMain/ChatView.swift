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
                                .accessibilityLabel("채팅 기록 로딩 중")
                                .accessibilityHint("이전 대화 내역을 불러오고 있습니다")
                                
                            Spacer()
                        }
                    } else if viewModel.messages.isEmpty {
                        VStack {
                            Spacer()
                          
                            Text("무조건 공감만 해드릴게요.\n대화를 시작해주세요.")
                                .muFont(.body1)
                                .multilineTextAlignment(.center)
                                .foregroundColor(.muSubText)
                                .accessibilityLabel("대화 시작 안내")
                                .accessibilityHint("아래 입력 필드에서 메시지를 작성하여 대화를 시작하세요")
                          
                            Spacer()
                        }
                    } else {
                        // 실제 메시지 표시
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(Array(viewModel.messages.enumerated()), id: \.element.id) { index, message in
                                    VStack(spacing: 0) {
                                        // 날짜 변경 체크: 이전 메시지와 다른 날짜면 ChatDateBadgeView 표시
                                        if viewModel.shouldShowDateBadge(for: message, at: index) {
                                            ChatDateBadgeView(date: message.createdAt)
                                                .padding(.bottom, 20)
                                        }
                                        
                                        // 게스트 변경 체크: AI 메시지에서 이전과 다른 게스트면 GuestChangeNotificationView 표시
                                        if let guestChange = viewModel.shouldShowGuestChange(for: message, at: index) {
                                            GuestChangeNotificationView(from: guestChange.from, to: guestChange.to)
                                                .padding(.bottom, 20)
                                        }
                                        
                                        MessageRowView(message: message)
                                    }
                                }
                                
                                // 로딩 상태일 때 빈 메시지로 AIMessageView 표시
                                if viewModel.isLoading {
                                    let loadingUser = MessageUser(name: viewModel.selectedGuestType.displayName,
                                                                  isCurrentUser: false,
                                                                  guestType: viewModel.selectedGuestType)
                                    let loadingMessage = ChatEntity(user: loadingUser, text: "")
                                    MessageRowView(message: loadingMessage)
                                        //.padding(.horizontal, 8)
                                }
                            }
                            .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                            .padding(.vertical, 20)
                        }
                        .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                        .accessibilityLabel("채팅 메시지 목록")
                        .accessibilityHint("위아래로 스크롤하여 대화 내용을 확인할 수 있습니다")
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
                viewModel.loadCurrentGuest()
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
                .resizable()
                .renderingMode(.template)
                .foregroundStyle(.muText)
                .frame(width: 40, height: 40)
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
