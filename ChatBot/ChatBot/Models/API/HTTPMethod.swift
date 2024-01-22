//
//  HTTPMethod.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/05.
//

import Foundation

enum HTTPMethod: CustomStringConvertible {
    case post
    
    var description: String {
        switch self {
        case .post:
            return "POST"
        }
    }
}
