//
//  MessageBubbleView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct MessageBubbleView: View {
    let message: ChatEntity
    
    var body: some View {
        HStack {
            if message.user.isCurrentUser {
                Spacer()
                userMessageView
            } else {
                aiMessageView
                Spacer()
            }
        }
    }
    
    private var userMessageView: some View {
        Text(message.text)
            .font(.custom("Pretendard-Regular", size: 16))
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.green)
            .cornerRadius(18)
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color.green, lineWidth: 1)
            )
    }
    
    private var aiMessageView: some View {
        HStack(alignment: .top, spacing: 8) {
            // AI Avatar
            if let guestType = message.user.guestType {
                Circle()
                    .fill(guestType == .ybj ? Color.red : Color.blue)
                    .frame(width: 32, height: 32)
                    .overlay(
                        Text(String(guestType.displayName.first ?? "?"))
                            .font(.custom("Pretendard-Bold", size: 14))
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .font(.custom("Pretendard-Regular", size: 16))
                    .foregroundColor(.primary)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(.systemGray6))
                    .cornerRadius(18)
                
                Text("대화 상대를 음성님으로 변경하였습니다.")
                    .font(.custom("Pretendard-Regular", size: 12))
                    .foregroundColor(.gray)
                    .padding(.leading, 16)
            }
        }
    }
}

#Preview {
    let sampleUser = MessageUser(name: "테스트", isCurrentUser: true)
    let sampleMessage = ChatEntity(
        conversationId: "test",
        user: sampleUser,
        text: "안녕하세요!"
    )
    
    MessageBubbleView(message: sampleMessage)
}