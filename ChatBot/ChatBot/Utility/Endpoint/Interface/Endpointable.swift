//
//  Endpointable.swift
//  ChatBot
//
//  Created by 김경록 on 1/10/24.
//

import Foundation

protocol Endpointable {
    var url: URL? { get }
    var accessKey: String? { get }
    var httpMethod: String { get }
    var httpHeader: [String: String] { get }
    var httpBodyContent: UserContentModel { get set }
    var useAuthorization: Bool { get }
}
