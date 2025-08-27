//
//  GuestSelectionCard.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

struct GuestSelectionCard: View {
    let viewModel: GuestSelectionViewModel
    let guest: GuestEntity
    
    var body: some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 14)
                .frame(width: 150, height: 210)
                .foregroundStyle(Color.muBackground)
                .overlay {
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.muPrimary,
                                lineWidth: viewModel.selectedGuest == guest ? 5 : 1)
                }
            
            VStack(spacing: 20) {
                guest.image
                    .resizable()
                    .frame(width: 117, height: 117)
                    .foregroundStyle(Color.muSecondary)
                    .padding()
                
                Text(guest.name)
                    .muFont(.title1)
                    .foregroundStyle(.muText)
            }
        }
    }
}
