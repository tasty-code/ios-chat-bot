//
//  APIName.swift
//  ChatBot
//
//  Created by 전성수 on 1/10/24.
//

import Foundation

enum APIName {
    case openAI
    
    var description: String {
        switch self {
        case .openAI: "openAI_APIKey"
        }
    }
}
