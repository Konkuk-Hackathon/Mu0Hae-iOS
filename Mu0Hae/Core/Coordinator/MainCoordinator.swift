//
//  MainCoordinator.swift
//  Mine4Cut
//
//  Created by Seoyeon Choi on 8/3/25.
//

import SwiftUI

typealias MainCoordinatorProtocol = Navigatable & SheetPresentable & FullScreenPresentable

@MainActor
@Observable
final class MainCoordinator: MainCoordinatorProtocol {
    
    var path: [AppPage] = []
    var sheet: Sheet?
    var fullScreen: FullScreen?
    private var container: DIContainer?
    
    func inject(_ container: DIContainer) {
        self.container = container
    }
    
    func push(_ page: AppPage) {
        path.append(page)
    }
    
    func pop() {
        _ = path.popLast()
    }
    
    func popTo(_ page: AppPage) {
        if let index = path.firstIndex(of: page) {
            path.removeSubrange(index+1..<path.count)
        } else {
            path.append(page)
        }
    }
    
    func popToRoot() {
        path.removeAll()
    }
    
    func presentSheet(_ sheet: Sheet) {
        self.sheet = sheet
    }
    
    func dismissSheet() {
        self.sheet = nil
    }
    
    func presentFullScreen(_ fullScreen: FullScreen) {
        self.fullScreen = fullScreen
    }
    
    func dismissFullScreen() {
        self.fullScreen = nil
    }
    
    func buildPage(_ page: AppPage) -> some View {
        switch page {
        case .chat:
            if let container = container {
                ChatView(viewModel: container.createViewModels().chatViewModel)
            }
        case .guestSelection:
            GuestSelectionView()
        }
    }
    
    // TODO: 화면 정해지면 수정!
    func buildSheet(_ sheet: Sheet) -> some View {
        switch sheet {
        case .selectTag:
            Text("Select Tag")
        }
    }
    
    func buildFullScreen(_ fullScreen: FullScreen) -> some View {
        switch fullScreen {
        case .onboardingSuccess: Text("Onboarding Success")
        case .photoZoom: Text("Photo Zoom")
        }
    }
}
