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
            .font(.custom("Pretendard-Regular", size: 12))
            .foregroundColor(.gray)
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
            .background(Color(.systemGray6))
            .cornerRadius(12)
    }
}

#Preview {
    GuestChangeNotificationView(from: .ybj, to: .key)
}