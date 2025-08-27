//
//  CoordinatorProtocol.swift
//  Mine4Cut
//
//  Created by Seoyeon Choi on 8/3/25.
//

import SwiftUI

@MainActor
protocol Navigatable: AnyObject {
    associatedtype AppPage: Hashable
    associatedtype ContentView: View
    
    var path: [AppPage] { get set }
    
    func push(_ page: AppPage)
    func pop()
    func popTo(_ page: AppPage)
    func popToRoot()
    
    @ViewBuilder
    func buildPage(_ page: AppPage) -> ContentView
}

@MainActor
protocol SheetPresentable: AnyObject {
    associatedtype Sheet: Identifiable
    associatedtype SheetView: View
    
    var sheet: Sheet? { get set }
    
    func presentSheet(_ sheet: Sheet)
    func dismissSheet()
    
    @ViewBuilder
    func buildSheet(_ sheet: Sheet) -> SheetView
}

@MainActor
protocol FullScreenPresentable: AnyObject {
    associatedtype FullScreen: Identifiable
    associatedtype FullScreenView: View
    
    var fullScreen: FullScreen? { get set }
    
    func presentFullScreen(_ fullScreen: FullScreen)
    func dismissFullScreen()
    
    @ViewBuilder
    func buildFullScreen(_ fullScreen: FullScreen) -> FullScreenView
}
