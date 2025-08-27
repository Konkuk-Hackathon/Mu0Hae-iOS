//
//  AIMessageView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct AIMessageView: View {
    let message: ChatEntity
    @State private var isPlaying: Bool = false
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // TODO: 이미지로 교체
            if let guestType = message.user.guestType {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 54, height: 54)
                    .overlay(
                        // TODO: 캐릭터 지정 시 교체
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    )
            }
            
            // Message Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 8) {
                    Text(message.text.forceCharWarpping)
                        .muFont(.body2)
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.muLightGray)
                        .cornerRadius(18)
                        .frame(maxWidth: 190, alignment: .leading)
                    
                    // Speaker Button
                    Button(action: {
                        // TODO: TTS
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                            .font(.system(size: 16))
                            .foregroundColor(Color.muSubText)
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
    }
}

#Preview {
    let sampleUser = MessageUser(name: "유병재", isCurrentUser: false, guestType: .ybj)
    let sampleMessage = ChatEntity(
        conversationId: "test",
        user: sampleUser,
        text: "안녕하세요! 오늘 기분은 어떠세요? 제 이름은 박성근이에요. 오늘 하루동안 이걸 만드느라 정신이 많이 없네요 츠하하하하"
    )
    
    AIMessageView(message: sampleMessage)
}
