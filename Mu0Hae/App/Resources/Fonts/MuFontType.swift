//
//  MuFontType.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

enum MuFontType {
    case title1
    case title2
    case buttonTitle
    case body1
    case body2
    case body3
    
    var fontName: FontNameType {
        switch self {
        case .title1, .title2: .bookkBold
        case .buttonTitle: .notoMedium
        case .body1, .body2, .body3: .notoRegular
        }
    }
    
    var fontSize: CGFloat {
        switch self {
        case .title1: 18
        case .title2: 15
        case .buttonTitle, .body1: 14
        case .body2: 12
        case .body3: 11
        }
    }
    
    var lineHeight: CGFloat {
        switch self {
        case .title1: 120
        case .title2, .buttonTitle: 130
        case .body1: 140
        case .body2, .body3: 135
        }
    }
    
    
    var letterSpacing: CGFloat {
        switch self {
        case .title1, .body1: -0.7
        case .title2: -0.6
        case .buttonTitle: -0.5
        case .body2: -0.3
        case .body3: -0.4
        }
    }
}

enum FontNameType: String {
    case notoRegular = "NotoSansKR-Regular"
    case notoMedium = "NotoSansKR-Medium"
    case bookkLight = "BookkMyungjo-Lt"
    case bookkBold = "BookkMyungjo-Bd"
}
