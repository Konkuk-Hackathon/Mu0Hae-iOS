//
//  ChatDateBadgeView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct ChatDateBadgeView: View {
    let date: String
    
    init(date: Date = Date()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        self.date = formatter.string(from: date)
    }
    
    var body: some View {
        Text(date)
            .muFont(.body3)
            .foregroundColor(Color.muSubText)
            .cornerRadius(12)
            .accessibilityLabel("날짜 구분선")
            .accessibilityValue(date)
    }
}

#Preview {
    ChatDateBadgeView()
}
