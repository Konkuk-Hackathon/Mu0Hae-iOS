//
//  GuestChangeNotificationView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

struct GuestChangeNotificationView: View {
    let from: GuestType?
    let to: GuestType
    
    var body: some View {
        Text("대화 상대를 \(to.displayName)님으로 변경하였습니다.")
            .muFont(.body3)
            .foregroundColor(Color("muSubText"))
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color("muLightGray"))
            .cornerRadius(12)
            .accessibilityLabel("대화 상대 변경 알림")
            .accessibilityValue("대화 상대를 \(to.displayName)님으로 변경하였습니다")
    }
}

#Preview {
    GuestChangeNotificationView(from: .ubyung, to: .key)
}
