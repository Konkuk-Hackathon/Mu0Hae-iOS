//
//  View+MuFont.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/27/25.
//

import SwiftUI

extension View {
    /// 뷰에 muFont 메소드를 활용하여 폰트를 지정합니다.
    func muFont(_ type: MuFontType) -> some View {
        let font = UIFont(name: type.fontName.rawValue, size: type.fontSize) ?? UIFont.systemFont(ofSize: type.fontSize)
        let calculatedLineHeight = type.fontSize * (type.lineHeight / 100)
        let kerning = (type.letterSpacing / 100) * type.fontSize
        let lineSpacing = max(0, calculatedLineHeight - font.lineHeight)
        let verticalPadding = max(0, lineSpacing / 2)

        return self
            .font(Font(font))
            .kerning(kerning)
            .lineSpacing(lineSpacing)
            .padding(.vertical, verticalPadding)
    }
}
