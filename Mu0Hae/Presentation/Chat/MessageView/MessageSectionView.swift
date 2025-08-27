//
//  MessageSectionView.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/25/25.
//

import SwiftUI

enum MessageSectionType {
    case date(Date)
    case guestChange(from: GuestType?, to: GuestType)
}

struct MessageSectionView: View {
    let sectionType: MessageSectionType
    let messages: [ChatEntity]
    
    var body: some View {
        VStack(spacing: 12) {
            sectionHeaderView
            
            ForEach(messages) { message in
                MessageRowView(message: message)
            }
        }
    }
    
    @ViewBuilder
    private var sectionHeaderView: some View {
        switch sectionType {
        case .date(let date):
            ChatDateBadgeView(date: date)
                .padding(.vertical, 8)
            
        case .guestChange(let from, let to):
            GuestChangeNotificationView(from: from, to: to)
                .padding(.vertical, 4)
        }
    }
    
}

// MARK: - MessageSection Helper
struct MessageSection {
    let type: MessageSectionType
    let messages: [ChatEntity]
    
    static func groupMessages(_ messages: [ChatEntity]) -> [MessageSection] {
        var sections: [MessageSection] = []
        var currentDate: Date?
        var currentGuest: GuestType?
        var currentMessages: [ChatEntity] = []
        
        for message in messages {
            let messageDate = Calendar.current.startOfDay(for: message.createdAt)
            let messageGuest = message.user.guestType
            
            // 날짜가 변경된 경우
            if let date = currentDate, !Calendar.current.isDate(date, inSameDayAs: messageDate) {
                if !currentMessages.isEmpty {
                    sections.append(MessageSection(type: .date(date), messages: currentMessages))
                    currentMessages = []
                }
                currentDate = messageDate
            }
            
            // 게스트가 변경된 경우 (AI 메시지만 해당)
            if !message.user.isCurrentUser && messageGuest != currentGuest {
                if !currentMessages.isEmpty {
                    sections.append(MessageSection(type: currentDate != nil ? .date(currentDate!) : .date(messageDate), messages: currentMessages))
                    currentMessages = []
                }
                
                if currentGuest != messageGuest {
                    sections.append(MessageSection(type: .guestChange(from: currentGuest, to: messageGuest!), messages: []))
                }
                currentGuest = messageGuest
            }
            
            if currentDate == nil {
                currentDate = messageDate
            }
            
            currentMessages.append(message)
        }
        
        // 마지막 섹션 추가
        if !currentMessages.isEmpty, let date = currentDate {
            sections.append(MessageSection(type: .date(date), messages: currentMessages))
        }
        
        return sections
    }
}

#Preview {
    let sampleUser1 = MessageUser(name: "나", isCurrentUser: true)
    let sampleUser2 = MessageUser(name: "유병재", isCurrentUser: false, guestType: .ybj)
    
    let sampleMessages = [
        ChatEntity(conversationId: "test", user: sampleUser1, text: "안녕하세요!"),
        ChatEntity(conversationId: "test", user: sampleUser2, text: "네, 안녕하세요! 오늘 기분이 어떠신가요?")
    ]
    
    MessageSectionView(
        sectionType: .date(Date()),
        messages: sampleMessages
    )
}
