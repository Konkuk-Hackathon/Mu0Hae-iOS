//
//  AIMessageView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI
import AVFAudio

struct AIMessageView: View {
    let message: ChatEntity
    
    @StateObject private var viewModel = TTSViewModel()
    
    @State var isPlaying: Bool = false
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
                    .accessibilityLabel("\(message.user.guestType!.displayName) 프로필 사진")
                    .accessibilityHidden(true)
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
                        .accessibilityLabel("\(message.user.name)가 답변을 작성 중입니다")
                        .accessibilityHint("잠시 후 답변이 나타납니다")
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
                            .accessibilityLabel("\(message.user.name)의 메시지")
                            .accessibilityValue(message.text)
                    }
                    
                    // Speaker Button (only show when not loading)
                    if !isLoading {
                        Button {
                            isPlaying.toggle()
                            if let speakerId = message.user.guestType?.rawValue {
                                Task {
                                    await viewModel.fetchAndPlay(
                                        text: message.text,
                                        speakerId: speakerId
                                    )
                                }
                            } else {
                                print("❌ speakerId가 존재하지 않습니다.")
                                isPlaying = false
                            }
                            
                        } label: {
                            if viewModel.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .frame(width: 20, height: 20)
                                    .padding(4)
                            } else {
                                Image(.icSpeaker)
                                    .foregroundColor(.muSubText)
                                    .padding(4)
                            }
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
