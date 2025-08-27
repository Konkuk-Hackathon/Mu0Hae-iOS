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
            Text(message.text.forceCharWarpping)
                .muFont(.body2)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color.green)
                .cornerRadius(18)
                .frame(maxWidth: 190, alignment: .trailing)
        }
    }
}

#Preview {
    let sampleUser = MessageUser(name: "나", isCurrentUser: true)
    let sampleMessage = ChatEntity(
        user: sampleUser,
        text: "안녕하세요!"
    )
    
    UserMessageView(message: sampleMessage)
}
