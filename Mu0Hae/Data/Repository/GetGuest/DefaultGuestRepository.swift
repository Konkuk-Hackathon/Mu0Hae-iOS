//
//  DefaultGuestRepository.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation

final class DefaultGuestRepository: GuestRepository {
    private let guestService: GuestService
    
    init(guestService: GuestService) {
        self.guestService = guestService
    }
    
    func getGuests() async throws -> [GuestEntity] {
        let response = try await guestService.getGuestList()
        return response.toGuestListEntity()
    }
}
