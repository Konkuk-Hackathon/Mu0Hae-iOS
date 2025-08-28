//
//  GuestSelectionViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

@Observable
final class GuestSelectionViewModel {
    let guestUseCase: GuestUseCase
    
    var guestList: [GuestEntity] = []
    var isShowingPopup: Bool = false
    var selectedGuest: GuestType = .ubyung
    
    init (guestUseCase: GuestUseCase) {
        self.guestUseCase = guestUseCase
    }
    
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
    
    func fetchGuests() async {
        do {
            let guests = try await guestUseCase.getGuestList()
            self.guestList = guests
            print("🎉 게스트 목록 불러오기 성공:", guests)
        } catch {
            print("❌ 게스트 목록 불러오기 실패:", error.localizedDescription)
        }
    }
}
