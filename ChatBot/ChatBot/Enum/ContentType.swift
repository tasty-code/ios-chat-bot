//
//  ContentType.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/09.
//

import Foundation

enum ContentType {
    case json
    var value: String {
        switch self {
        case .json:
            return "application/json"
        }
    }
}
