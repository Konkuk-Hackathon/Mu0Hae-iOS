//
//  SplashView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.muPrimary.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(.splash)
                    .resizable()
                    .frame(width: 230, height: 230)
                
                Image(.splashTitle)
            }
        }
    }
}

#Preview {
    SplashView()
}
