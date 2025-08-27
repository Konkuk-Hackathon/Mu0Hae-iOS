//
//  MessageRowView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct MessageRowView: View {
    let message: ChatEntity
    
    var body: some View {
        HStack {
            if message.user.isCurrentUser {
                Spacer()
                UserMessageView(message: message)
            } else {
                AIMessageView(message: message)
                Spacer()
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(message.user.isCurrentUser ? "내가 보낸 메시지" : "\(message.user.name)가 보낸 메시지")
    }
}

#Preview {
    let sampleUser = MessageUser(name: "테스트", isCurrentUser: false, guestType: .ubyung)
    let sampleMessage = ChatEntity(
        user: sampleUser,
        text: "안녕하세요! 오늘 기분은 어떠세요?"
    )
    
    MessageRowView(message: sampleMessage)
}
