//
//  GuestEntity.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

// TODO: GuestType과 통합
enum GuestEntity: CaseIterable {
    case ybj
    case key
    
    var name: String {
        switch self {
        case .ybj: return "유병재"
        case .key: return "키"
        }
    }
    
    var description: String {
        switch self {
        case .ybj: return "왜 그런지 몰라도, 어떤 사연이든\n다 공감해드립니다."
        case .key: return "샤이니 T 아니고 키 입니다.\n노력해서 공감하겠습니다."
        }
    }
    
    var image: Image {
        switch self {
        case .ybj: Image(.ybj)
        case .key: Image(.key)
        }
    }
}
