//
//  GuestRepository.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

protocol GuestRepository {
    func getGuests() async throws -> [GuestEntity]
}
