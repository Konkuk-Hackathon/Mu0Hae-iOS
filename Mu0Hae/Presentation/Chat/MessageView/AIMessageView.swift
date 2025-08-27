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
    @State private var animationPhase = 0
    
    var isLoading: Bool {
        message.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            if let guestType = message.user.guestType {
                guestType.image
                    .resizable()
                    .frame(width: 46, height: 46)
            }
            
            // Message Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 0) {
                    if isLoading {
                        // Loading animation
                        HStack(spacing: 4) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.muSubText)
                                    .frame(width: 6, height: 6)
                                    .scaleEffect(animationPhase == index ? 1.2 : 0.8)
                                    .animation(
                                        Animation.easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                        value: animationPhase
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.muLightGray)
                        .cornerRadius(18)
                        .frame(maxWidth: 190, alignment: .leading)
                    } else {
                        // Regular message
                        Text(message.text.forceCharWarpping)
                            .muFont(.body2)
                            .foregroundColor(.muText)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.muLightGray)
                            .cornerRadius(14)
                            .frame(maxWidth: 230, alignment: .leading)
                    }
                    
                    // Speaker Button (only show when not loading)
                    if !isLoading {
                        Button {
                            // TODO: TTS
                            isPlaying.toggle()
                        } label: {
                            Image(.icSpeaker)
                                .foregroundColor(.muSubText)
                                .padding(4)
                        }
                    } else {
                        // Placeholder space when loading
                        Color.clear
                            .frame(width: 24, height: 24)
                    }
                }
            }
        }
        .onAppear {
            if isLoading {
                withAnimation {
                    animationPhase = 2
                }
            }
        }
    }
}

#Preview {
    let sampleUser = MessageUser(name: "유병재", isCurrentUser: false, guestType: .ubyung)
    let sampleMessage = ChatEntity(
        user: sampleUser,
        text: "안녕하세요! 오늘 기분은 어떠세요? 제 이름은 박성근이에요. 오늘 하루동안 이걸 만드느라 정신이 많이 없네요 츠하하하하"
    )
    
    AIMessageView(message: sampleMessage)
}
