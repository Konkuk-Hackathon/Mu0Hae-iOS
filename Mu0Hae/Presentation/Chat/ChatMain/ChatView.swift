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
                Group {
                    if viewModel.isLoadingHistory {
                        // 채팅 기록 로딩 중
                        VStack {
                            Spacer()
                            ProgressView("채팅 기록을 불러오는 중...")
                                .muFont(.body2)
                                .foregroundColor(Color("muSubText"))
                                .accessibilityLabel("채팅 기록 로딩 중")
                                .accessibilityHint("이전 대화 내역을 불러오고 있습니다")
                            Spacer()
                        }
                    } else if viewModel.messages.isEmpty {
                        // 화면 정중앙에 환영 메시지
                        VStack {
                            Spacer()
                            Text("무조건 공감만 해드릴게요.\n대화를 시작해주세요.")
                                .muFont(.body1)
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color("muSubText"))
                                .accessibilityLabel("대화 시작 안내")
                                .accessibilityHint("아래 입력 필드에서 메시지를 작성하여 대화를 시작하세요")
                            Spacer()
                        }
                    } else {
                        // 실제 메시지 표시
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(viewModel.messages) { message in
                                    MessageRowView(message: message)
                                        .padding(.horizontal, 8)
                                }
                                
                                // 로딩 상태일 때 빈 메시지로 AIMessageView 표시
                                if viewModel.isLoading {
                                    let loadingUser = MessageUser(name: viewModel.selectedGuestType.displayName, isCurrentUser: false, guestType: viewModel.selectedGuestType)
                                    let loadingMessage = ChatEntity(user: loadingUser, text: "")
                                    MessageRowView(message: loadingMessage)
                                        .padding(.horizontal, 8)
                                }
                            }
                            .padding()
                            .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                        }
                        .rotationEffect(.degrees(180)).scaleEffect(x: -1, y: 1, anchor: .center)
                        .accessibilityLabel("채팅 메시지 목록")
                        .accessibilityHint("위아래로 스크롤하여 대화 내용을 확인할 수 있습니다")
                    }
                }
                
                ChatInputView(chatViewModel: viewModel)
            }
            .background(Color.muBackground)
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
                        .accessibilityLabel("무해 앱 로고")
                        .accessibilityHidden(true)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        coordiinator.push(.guestSelection)
                    }) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                    .accessibilityLabel("설정 메뉴")
                    .accessibilityHint("탭하여 대화 상대를 변경할 수 있습니다")
                }
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

#Preview {
    let container = DIContainer()
    ChatView()
        .inject(container)
        .environment(MainCoordinator())
}
