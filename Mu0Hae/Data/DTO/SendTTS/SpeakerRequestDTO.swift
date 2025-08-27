//
//  SpeakerRequestDTO.swift
//  Mu0Hae
//
//  Created by Seoyeon Choi on 8/28/25.
//

struct SpeakerRequestDTO: Codable {
    let text: String
    let mode: String
    let speaker_id: String
    
    init(text: String, mode: String, speaker_id: String) {
        self.text = text
        self.mode = mode
        self.speaker_id = speaker_id
    }
    
    init(from chatEntity: ChatEntity, guestType: GuestType) {
        self.text = chatEntity.text
        self.mode = "zero_shot"
        self.speaker_id = guestType.rawValue
    }
}
