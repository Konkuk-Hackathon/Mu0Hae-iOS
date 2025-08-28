//
//  GuestUseCase.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation

protocol GuestUseCase {
    func getGuestList() async throws -> [GuestEntity]
}

final class DefaultGuestUseCase: GuestUseCase {
    private let repository: GuestRepository
    
    init(repository: GuestRepository) {
        self.repository = repository
    }
    
    func getGuestList() async throws -> [GuestEntity] {
        try await repository.getGuests()
    }
}
