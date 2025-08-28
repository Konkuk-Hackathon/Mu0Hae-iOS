//
//  GuestDescriptionPopup.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

struct GuestDescriptionPopup: View {
    let viewModel: GuestSelectionViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
            
            VStack(spacing: 0) {
                viewModel.selectedGuest.image
                    .resizable()
                    .frame(width: 86, height: 86)
                    .foregroundStyle(.muSecondary)
                    .padding(.bottom, 15)
                
                Text(viewModel.selectedGuest.displayName)
                    .muFont(.title1)
                    .foregroundStyle(.muText)
                    .padding(.bottom, 6)
                
                Text(viewModel.selectedGuest.description)
                    .muFont(.title2)
                    .foregroundStyle(.muSubText)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                
                HStack(spacing: 20) {
                    GuestSelectionButton(title: "취소",
                                         fontColor: .muSubText,
                                         backgroundColor: .muLightGray,
                                         action: { viewModel.hidePopup() } )
                    
                    GuestSelectionButton(title: "설정하기",
                                         fontColor: .muBackground,
                                         backgroundColor: .muPrimary,
                                         action: { viewModel.hidePopup() } )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 30)
            .background(Color.muBackground)
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .ignoresSafeArea()
    }
}

private struct GuestSelectionButton: View {
    var title: String
    var fontColor: Color
    var backgroundColor: Color
    var action: () -> Void
    
    var body: some View {
        RoundedRectangle(cornerRadius: 8)
            .frame(width: 120, height: 38)
            .foregroundStyle(backgroundColor)
            .overlay {
                Text(title)
                    .muFont(.buttonTitle)
                    .foregroundStyle(fontColor)
            }
            .onTapGesture { action() }
    }
}
