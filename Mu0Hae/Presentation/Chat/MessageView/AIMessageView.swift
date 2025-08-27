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
                    .accessibilityLabel("\(message.user.name) 프로필 사진")
                    .accessibilityHidden(true)
            }
            
            // Message Content
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .center, spacing: 8) {
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
                        .accessibilityLabel("\(message.user.name)가 답변을 작성 중입니다")
                        .accessibilityHint("잠시 후 답변이 나타납니다")
                    } else {
                        // Regular message
                        Text(message.text.forceCharWarpping)
                            .muFont(.body2)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.muLightGray)
                            .cornerRadius(18)
                            .frame(maxWidth: 190, alignment: .leading)
                            .accessibilityLabel("\(message.user.name)의 메시지")
                            .accessibilityValue(message.text)
                    }
                    
                    // Speaker Button (only show when not loading)
                    if !isLoading {
                        Button(action: {
                            // TODO: TTS
                            isPlaying.toggle()
                        }) {
                            Image(systemName: isPlaying ? "speaker.wave.2.fill" : "speaker.fill")
                                .font(.system(size: 16))
                                .foregroundColor(Color.muSubText)
                                .frame(width: 24, height: 24)
                        }
                        .accessibilityLabel(isPlaying ? "음성 재생 중지" : "음성으로 듣기")
                        .accessibilityHint(isPlaying ? "탭하여 음성 재생을 중지합니다" : "탭하여 메시지를 음성으로 들을 수 있습니다")
                    } else {
                        // Placeholder space when loading
                        Color.clear
                            .frame(width: 24, height: 24)
                            .accessibilityHidden(true)
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
