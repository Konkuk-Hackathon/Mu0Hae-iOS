//
//  Routes.swift
//  Mine4Cut
//
//  Created by Seoyeon Choi on 8/9/25.
//

import SwiftUI

// TODO: 화면 디자인 끝나고 수정
enum AppPage: Hashable {
    case chat // 메인 탭뷰
    
    case guestSelection // 게스트 선택 뷰
    
    var id: String { String(describing: self) }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: AppPage, rhs: AppPage) -> Bool {
        lhs.id == rhs.id
    }
}

enum Sheet: Identifiable {
    case selectTag
    
    var id: String { String(describing: self) }
}

enum FullScreen: Identifiable {
    case onboardingSuccess
    case photoZoom
    
    var id: String { String(describing: self) }
}
