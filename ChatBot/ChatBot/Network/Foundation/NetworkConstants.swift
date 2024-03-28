//
//  NetworkConstants.swift
//  ChatBot
//
//  Created by EUNJU on 3/28/24.
//

import Foundation

enum HeaderType {
    case basic
}

enum HTTPHeaderField: String {
    case contentType = "Content-Type"
    case accesstoken = "Authorization"
}

enum ContentType: String {
    case json = "application/json"
}

enum RequestParameter {
    case query(_ query: [String: Any])
    case queryBody(_ query: [String: Any], _ body: [String: Any])
    case requestBody(_ body: [String: Any])
    case requestPlain
}
