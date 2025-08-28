//
//  Mu0HaeApp.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

@main
struct Mu0HaeApp: App {
    private let container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .inject(container)
        }
    }
}

struct RootView: View {
    @State private var showSplash = true
    
    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else {
                CoordinatorView()
            }
        }
        .onAppear {
            Task {
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                withAnimation {
                    showSplash = false
                }
            }
        }
    }
}
