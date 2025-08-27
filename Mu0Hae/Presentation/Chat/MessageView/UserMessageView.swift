//
//  UserMessageView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct UserMessageView: View {
    let message: ChatEntity
    
    var body: some View {
        VStack(alignment: .trailing, spacing: 4) {
            Text(message.text)
                .font(.custom("Pretendard-Regular", size: 16))
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.green)
                .cornerRadius(18)
            
            Text(timeString)
                .font(.custom("Pretendard-Regular", size: 11))
                .foregroundColor(.gray)
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: message.createdAt)
    }
}

#Preview {
    let sampleUser = MessageUser(name: "나", isCurrentUser: true)
    let sampleMessage = ChatEntity(
        conversationId: "test",
        user: sampleUser,
        text: "안녕하세요!"
    )
    
    UserMessageView(message: sampleMessage)
}