//
//  ContentType.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

enum ContentType {
    case json
    
    var description: String {
        switch self {
        case .json: "application/json"
        }
    }
}
