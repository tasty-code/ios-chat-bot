//
//  BaseURL.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

enum BaseURL {
    case openAI

    var description: String {
        switch self {
        case.openAI: "https://api.openai.com/v1/chat/completions"
        }
    }
}
