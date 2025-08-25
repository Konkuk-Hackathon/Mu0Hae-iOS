//
//  CoordinatorView.swift
//  Mine4Cut
//
//  Created by Seoyeon Choi on 8/9/25.
//

import SwiftUI

struct CoordinatorView: View {
    
    @State private var coordinator = MainCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.buildPage(.chat)
                .navigationDestination(for: AppPage.self) { page in
                    coordinator.buildPage(page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.buildSheet(sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreen) { fullScreen in
                    coordinator.buildFullScreen(fullScreen)
                }
        }
        .environment(coordinator)
    }
}
