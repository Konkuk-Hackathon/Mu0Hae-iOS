//
//  UserDefaultsError.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

import Foundation

enum UserDefaultsError: LocalizedError {
  case keyNotFound(key: String)
  
  var errorDescription: String? {
    switch self {
    case .keyNotFound(let key):
      return "UserDefaults에 찾으려는 key \(key)가 없습니다"
    }
  }
}
