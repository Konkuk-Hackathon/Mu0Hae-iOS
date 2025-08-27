//
//  GuestSelectionView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct GuestSelectionView: View {
    @State var viewModel: GuestSelectionViewModel = .init()
    
    private let itemWidth: CGFloat = (UIApplication.screenWidth - 25 * 3) / 2
    private var columns: [GridItem] { [GridItem(.fixed(itemWidth)),
                                       GridItem(.fixed(itemWidth)) ] }
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                GuestSelectionNavigationBarView()
                
                LazyVGrid(columns: columns, spacing: 25) {
                    ForEach(1...4, id: \.self) { _ in
                        GuestSelectionCard()
                            .onTapGesture { viewModel.showPopup() }
                    }
                }
                .padding(.top, 25)
                
                Spacer()
            }
            
            if viewModel.isShowingPopup {
                GuestDescriptionPopup(viewModel: viewModel)
                    .zIndex(1)
            }
        }
        .background(Color.muBackground)
    }
}

private struct GuestSelectionNavigationBarView: View {
    @Environment(MainCoordinator.self) private var coordiinator
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                Image(.icBack)
                    .onTapGesture {
                        coordiinator.pop()
                    }
                Spacer()
            }
            .frame(height: 56)
            .padding(.horizontal, 20)
            .background(Color.muBackground)
            .overlay {
                Image(.imgSettingTItle)
            }
        }
    }
}
