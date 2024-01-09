//
//  HttpMethod.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/09.
//

import Foundation

enum HttpMethod {
    case get
    case post

    var value: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        }
    }
}
