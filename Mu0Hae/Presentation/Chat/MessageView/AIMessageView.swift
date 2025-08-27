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
            // AI Avatar with Image
            if let guestType = message.user.guestType {
                Circle()
                    .fill(Color(.systemGray6))
                    .frame(width: 32, height: 32)
                    .overlay(
                        // TODO: Replace with actual image based on guestType
                        Image(systemName: "person.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                    )
            }
            
            // Message Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 8) {
                    Text(message.text)
                        .font(.custom("Pretendard-Regular", size: 16))
                        .foregroundColor(.primary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color(.systemGray6))
                        .cornerRadius(18)
                    
                    // Speaker Button (centered)
                    Button(action: {
                        // TODO: Add TTS functionality
                        isPlaying.toggle()
                    }) {
                        Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .frame(width: 24, height: 24)
                    }
                }
                
                Text(timeString)
                    .font(.custom("Pretendard-Regular", size: 11))
                    .foregroundColor(.gray)
                    .padding(.trailing)
            }
        }
    }
    
    private var timeString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: message.createdAt)
    }
    
    private func avatarColor(for guestType: GuestType) -> Color {
        switch guestType {
        case .ybj: return Color.red
        case .key: return Color.blue
        }
    }
}

#Preview {
    let sampleUser = MessageUser(name: "유병재", isCurrentUser: false, guestType: .ybj)
    let sampleMessage = ChatEntity(
        conversationId: "test",
        user: sampleUser,
        text: "안녕하세요! 오늘 기분은 어떠세요?"
    )
    
    AIMessageView(message: sampleMessage)
}
