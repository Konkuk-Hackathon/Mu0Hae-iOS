//
//  RecordingError.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/27/25.
//

enum RecordingError: Error {
    case permissionError
    case audioError
    
    public var description: String {
        switch self {
        case .permissionError:
            return "사용자 권한 오류"
        case .audioError:
            return "음성 녹음 중 오류"
        }
    }
}
