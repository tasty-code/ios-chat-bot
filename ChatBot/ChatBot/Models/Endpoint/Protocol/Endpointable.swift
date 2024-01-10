//
//  Endpointable.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

protocol Endpointable {
    var url: URL? { get }
    var apiKey: String? { get }
    var httpMethod: HTTPMethods { get }
    var contentType: ContentTypes? { get }
    var httpBody: Data? { get }
}
