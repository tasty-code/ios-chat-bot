//
//  HTTPMethod.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

enum HTTPMethod{
    case get
    case post
    case fetch
    case put
    case delete
    
    var description: String {
        switch self {
        case .get: "GET"
        case .post: "POST"
        case .fetch: "FETCH"
        case .put: "PUT"
        case .delete: "DELETE"
        }
    }
}
