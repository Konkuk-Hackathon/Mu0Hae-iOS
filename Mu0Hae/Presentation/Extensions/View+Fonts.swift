//
//  View+Fonts.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

enum MineFontType {
    case headline1
    case title1
    case title2
    case title3
    case body1
    case body2
    case body3
    case body4
    case body4_2
    case body5
    case body5_2
    case label1
    case label2

    
    var fontName: PretendardWeight {
        switch self {
        case .headline1, .title1: return .bold
        case .title2: return .semibold
        case .title3, .body4, .body5_2, .label1, .label2: return .medium
        case .body1, .body2, .body3, .body4_2, .body5: return .regular
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .headline1: return 20
        case .title1: return 18
        case .title2: return 16
        case .title3: return 14
        case .body1: return 17
        case .body2: return 15
        case .body3: return 14
        case .body4, .body4_2, .label1: return 13
        case .body5, .body5_2: return 12
        case .label2: return 10
        }
    }
}

enum PretendardWeight: String {
    case bold = "Pretendard-Bold"
    case semibold = "Pretendard-SemiBold"
    case medium = "Pretendard-Medium"
    case regular = "Pretendard-Regular"
}

extension View {
    /// 뷰에 mineFont 메소드를 활용하여 폰트를 지정합니다.
    func mineFont(_ type: MineFontType) -> some View {
        let font = UIFont(name: type.fontName.rawValue, size: type.fontSize) ?? UIFont.systemFont(ofSize: type.fontSize)

        return self
            .font(Font(font))
    }
}
