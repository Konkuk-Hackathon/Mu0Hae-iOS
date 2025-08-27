//
//  GuestSelectionCard.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

struct GuestSelectionCard: View {
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 150, height: 210)
                .foregroundStyle(Color.muBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.muPrimary, lineWidth: 1)
                }
            
            VStack(spacing: 20) {
                Circle()
                    .frame(width: 117, height: 117)
                    .foregroundStyle(Color.muSecondary)
                    .padding()
                
                Text("유병재")
                    .muFont(.title1)
                    .foregroundStyle(.muText)
            }
        }
    }
}


#Preview {
    GuestSelectionCard()
}
