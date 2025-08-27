//
//  Date+.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/26/25.
//

import Foundation

// TODO: 형식 검증 필요
extension Date {
    func toISOString() -> String {
        let formatter = ISO8601DateFormatter()
        return formatter.string(from: self)
    }
}
