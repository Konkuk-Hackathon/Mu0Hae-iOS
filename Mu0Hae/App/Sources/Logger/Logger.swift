//
//  Logger.swift
//  Mu0Hae
//
//  Created by 박성근 on 8/26/25.
//

import os

public enum Logger {
    public static func log(message: String) {
        os_log("\(message)")
    }
}
