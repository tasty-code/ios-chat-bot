//
//  HeaderFieldName.swift
//  ChatBot
//
//  Created by 전성수 on 1/10/24.
//

import Foundation

enum HeaderFieldName {
    case contentType
    case authorization
    
    var description: String {
        switch self {
        case .contentType: "Content-Type"
        case .authorization: "Authorization"
        }
    }
}
