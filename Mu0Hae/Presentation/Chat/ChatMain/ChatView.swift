//
//  ChatView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @Environment(\.injected) private var injected: DIContainer
    
    init() {
        let tempContainer = DIContainer()
        self._viewModel = StateObject(wrappedValue: ChatViewModel(chatUseCase: tempContainer.useCases.chat))
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Messages ScrollView
                ScrollView {
                    LazyVStack(spacing: 0) {
                        // 실제 메시지 표시
                        if viewModel.messages.isEmpty {
                            // 더미 데이터 (메시지가 없을 때)
                            sampleMessageSections
                        } else {
                            // 실제 메시지 표시
                            ForEach(viewModel.messages) { message in
                                MessageRowView(message: message)
                                    .padding(.horizontal, 8)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                // Fixed Input at Bottom
                ChatInputView(chatViewModel: viewModel)
            }
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("무공해")
                        .font(.custom("Pretendard-Bold", size: 20))
                        .foregroundColor(.green)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "line.3.horizontal")
                            .foregroundColor(.primary)
                    }
                }
            }
        }
    }
    
    // MARK: - Sample Data (더미)
    private var sampleMessageSections: some View {
        VStack(spacing: 0) {
            let user = MessageUser(name: "나", isCurrentUser: true)
            let aiUser1 = MessageUser(name: "유병재", isCurrentUser: false, guestType: .ybj)
            let aiUser2 = MessageUser(name: "키", isCurrentUser: false, guestType: .key)
            
            let todayMessages = [
                ChatEntity(conversationId: "test", user: user, text: "오늘 나 너무 힘들어"),
                ChatEntity(conversationId: "test", user: aiUser1, text: "와, 진짜 힘드시구나. 그런 말씀만 들어도 나도 가슴이 아파요. 정말 안스럽다."),
                ChatEntity(conversationId: "test", user: user, text: "나기다가 오늘 비가지 어떻게 할까요?")
            ]
            
            let keyMessages = [
                ChatEntity(conversationId: "test", user: aiUser2, text: "아니 요즘 세상에 무슨 일이 다니는 사람이 이렇게 힘든 일이 있지? 진짜 진짜 안썩어요, 나미 너무 온몸이 힘나 많이 마잠지기도 대해 그냥 죄송하다고 그렇게에 대한 발병다고 요")
            ]
            
            MessageSectionView(sectionType: .date(Date()), messages: todayMessages)
            MessageSectionView(sectionType: .guestChange(from: .ybj, to: .key), messages: keyMessages)
        }
    }
}

#Preview {
    ChatView()
        .inject(DIContainer())
}
