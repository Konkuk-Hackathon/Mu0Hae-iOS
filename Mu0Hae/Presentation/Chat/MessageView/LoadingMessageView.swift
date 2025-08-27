//
//  LoadingMessageView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

import SwiftUI

struct LoadingMessageView: View {
    let guestType: GuestType
    @State private var animationPhase = 0
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            // AI Avatar (이미지 적용 예정)
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 32, height: 32)
                .overlay(
                    Text(String(guestType.displayName.first ?? "?"))
                        .muFont(.body3)
                        .foregroundColor(.gray)
                )
            
            // Loading bubble
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
            
            Spacer()
        }
        .onAppear {
            withAnimation {
                animationPhase = 2
            }
        }
    }
}

#Preview {
    LoadingMessageView(guestType: .ybj)
        .padding()
}
