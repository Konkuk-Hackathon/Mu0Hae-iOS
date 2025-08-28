//
//  GuestListDTO.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation

struct GuestListDTO: Decodable {
    let speakers: [String]
    
    func toGuestListEntity() -> [GuestEntity] {
        return speakers.map {
            GuestEntity(id: $0,
                        type: GuestType(rawValue: $0) ?? .ubyung)
        }
    }
}
