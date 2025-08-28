//
//  GuestSelectionViewModel.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

@Observable
final class GuestSelectionViewModel {
    private let userDefaultsService = UserDefaultsService()
    let guestUseCase: GuestUseCase
    
    var guestList: [GuestEntity] = []
    var isShowingPopup: Bool = false
    var selectedGuest: GuestType = .ubyung
    var isLoading: Bool = false
    
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
        isLoading = true
        defer { isLoading = false }
        
        do {
            let guests = try await guestUseCase.getGuestList()
            self.guestList = guests
            print("🎉 게스트 목록 불러오기 성공:", guests)
        } catch {
            print("❌ 게스트 목록 불러오기 실패:", error.localizedDescription)
        }
    }
    
    func saveCurrentGuest() {
        userDefaultsService.remove(key: .currentGuest)
        userDefaultsService.save(value: selectedGuest.rawValue, key: .currentGuest)
    }
    
    func loadCurrentGuest() {
        switch userDefaultsService.load(type: String.self, key: .currentGuest) {
        case .success(let guest):
            if let guestType = GuestType(rawValue: guest) {
                selectedGuest = guestType
                print("📥 저장된 채팅 상대 불러오기:", guestType)
            } else {
                print("❌ 저장된 값과 매칭되는 GuestType 없음:", guest)
            }
        case .failure(let error):
            print("❌ 불러오기 실패:", error)
        }
    }
}
