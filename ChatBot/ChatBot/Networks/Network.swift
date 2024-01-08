//
//  Network.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

struct Network {}

extension Network {
    enum HTTPMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    enum AuthorizationType: CustomStringConvertible {
        case bearer
        
        var description: String {
            switch self {
            case .bearer:
                return "Bearer"
            }
        }
    }
    
    enum HTTPContentType: CustomStringConvertible {
        case json
        
        var description: String {
            switch self {
            case .json:
                return "application/json"
            }
        }
    }
}
