//
//  Environment.swift
//  ChatBot
//
//  Created by 동준 on 1/5/24.
//

import Foundation

enum Environment {
    private enum Keys {
        static let api_key = "CHAT_API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()

    static let apiKey: String = {
        guard let string = Environment.infoDictionary[Keys.api_key] as? String else { fatalError("not exists in plist") }
        return string
    }()
}
