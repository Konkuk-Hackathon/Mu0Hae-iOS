//
//  GuestSelectionViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

@Observable
final class GuestSelectionViewModel {
    var isShowingPopup: Bool = false
    var selectedGuest: GuestEntity = .ybj
    
    func showPopup() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowingPopup = true
        }
    }
    
    func hidePopup() {
        withAnimation(.easeInOut(duration: 0.25)) {
            isShowingPopup = false
        }
    }
}
