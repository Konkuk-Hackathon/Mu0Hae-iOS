//
//  String+.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/26/25.
//

import Foundation

// TODO: 형식 검증 필요
extension String {
    func toDate() -> Date {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: self) ?? Date()
    }
    
    var forceCharWarpping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
}
