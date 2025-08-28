import Foundation

final class MockChatHistoryUseCase: ChatHistoryUseCase {
    func getChatHistory() async throws -> [ThreadEntity] {
        // Mock delay to simulate network call
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        return createMockThreads()
    }
    
    private func createMockThreads() -> [ThreadEntity] {
        let currentDate = Date()
        let yesterday = Calendar.current.date(byAdding: .day, value: -1, to: currentDate)!
        let twoDaysAgo = Calendar.current.date(byAdding: .day, value: -2, to: currentDate)!
        
        return [
            ThreadEntity(
                conversationId: "thread_1",
                createdTime: currentDate,
                messages: createOlderMessages()
            ),
            ThreadEntity(
                conversationId: "thread_2", 
                createdTime: yesterday,
                messages: createYesterdayMessages()
            ),
            ThreadEntity(
                conversationId: "thread_3",
                createdTime: twoDaysAgo,
                messages: createTodayMessages()
            )
        ]
    }
    
    private func createOlderMessages() -> [ChatEntity] {
        let baseTime = Calendar.current.date(byAdding: .day, value: -2, to: Date())!
        let user = MessageUser(id: "user_1", name: "사용자", isCurrentUser: true, guestType: nil)
        let ubyung = MessageUser(id: "ai_ubyung", name: "유병재", isCurrentUser: false, guestType: .ubyung)
        let key = MessageUser(id: "ai_key", name: "키", isCurrentUser: false, guestType: .key)
        
        return [
            ChatEntity(
                id: "msg_9",
                user: user,
                text: "건강한 식단에 대해 조언해 주세요!",
                createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_10",
                user: ubyung,
                text: "균형잡힌 식단이 가장 중요해요! 탄수화물, 단백질, 지방을 골고루 섭취하시고, 특히 야채를 많이 드세요.",
                createdAt: Calendar.current.date(byAdding: .hour, value: -3, to: baseTime)!.addingTimeInterval(120)
            ),
            ChatEntity(
                id: "msg_11",
                user: user,
                text: "감사합니다! 실천해볼게요.",
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_12",
                user: key,
                text: "좋은 하루 되세요~",
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: baseTime)!
            )
        ]
    }
    
    private func createYesterdayMessages() -> [ChatEntity] {
        let baseTime = Calendar.current.date(byAdding: .day, value: -1, to: Date())!
        let user = MessageUser(id: "user_1", name: "사용자", isCurrentUser: true, guestType: nil)
        let ubyung = MessageUser(id: "ubyung", name: "유병재", isCurrentUser: false, guestType: .ubyung)
        let key = MessageUser(id: "key", name: "키", isCurrentUser: false, guestType: .key)
        
        return [
            ChatEntity(
                id: "msg_5",
                user: user,
                text: "요즘 좋은 영화 추천해 주실 수 있나요?",
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_6",
                user: key,
                text: "최근에 본 영화 중에 '더 퍼스트 슬램덩크'가 정말 감동적이었어요! 애니메이션이지만 어른이 봐도 재밌습니다.",
                createdAt: Calendar.current.date(byAdding: .hour, value: -2, to: baseTime)!.addingTimeInterval(60)
            ),
            ChatEntity(
                id: "msg_7",
                user: user,
                text: "오 애니메이션도 좋네요! 다른 장르는 어떤 게 있을까요?",
                createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_8",
                user: key,
                text: "스릴러 좋아하시면 '결백'도 추천드려요. 정우성, 배두나 주연인데 긴장감 넘쳐요!",
                createdAt: Calendar.current.date(byAdding: .hour, value: -1, to: baseTime)!.addingTimeInterval(90)
            )
        ]
    }
    
    private func createTodayMessages() -> [ChatEntity] {
        let baseTime = Date()
        let user = MessageUser(id: "user_1", name: "사용자", isCurrentUser: true, guestType: nil)
        let ubyung = MessageUser(id: "ubyung", name: "유병재", isCurrentUser: false, guestType: .ubyung)
        let key = MessageUser(id: "key", name: "키", isCurrentUser: false, guestType: .key)
        
        return [
            ChatEntity(
                id: "msg_1",
                user: user,
                text: "안녕하세요! 오늘 날씨가 어떤가요?",
                createdAt: Calendar.current.date(byAdding: .minute, value: -30, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_2",
                user: ubyung,
                text: "안녕하세요! 오늘 날씨는 정말 좋네요. 맑고 따뜻해서 산책하기 딱 좋은 날씨입니다!",
                createdAt: Calendar.current.date(byAdding: .minute, value: -29, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_3",
                user: user,
                text: "네, 친구들과 한강 공원에서 피크닉을 할 예정이에요!",
                createdAt: Calendar.current.date(byAdding: .minute, value: -25, to: baseTime)!
            ),
            ChatEntity(
                id: "msg_4",
                user: ubyung,
                text: "와 정말 좋겠네요! 한강 피크닉은 언제 해도 즐거워요. 맛있는 음식도 챙겨가세요!",
                createdAt: Calendar.current.date(byAdding: .minute, value: -24, to: baseTime)!
            )
        ]
    }
}
