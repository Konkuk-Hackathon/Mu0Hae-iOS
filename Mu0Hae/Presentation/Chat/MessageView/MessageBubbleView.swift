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
            .muFont(.body1)
            .foregroundColor(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.muPrimary)
            .cornerRadius(18)
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
                            .muFont(.body3)
                            .foregroundColor(.white)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .muFont(.body1)
                    .foregroundColor(Color.muText)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color.muLightGray)
                    .cornerRadius(18)
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
