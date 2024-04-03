//
//  HttpMethod.swift
//  ChatBot
//
//  Created by 강창현 on 4/3/24.
//

enum HttpMethod<T: Encodable> {
    case GET
    case POST(body: T)
    case PUT(body: T)
    case PATCH(body: T)
    case DELETE(body: T)
    
    var type: (String, T?) {
        switch self {
        case .GET:
            ("GET", nil)
        case .POST(let body):
            ("POST", body)
        case .PUT(let body):
            ("PUT", body)
        case .PATCH(let body):
            ("PATCH", body)
        case .DELETE(let body):
            ("DELETE", body)
        }
    }
}
