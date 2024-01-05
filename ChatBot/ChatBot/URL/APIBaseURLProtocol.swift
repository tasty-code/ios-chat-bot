//
//  APIBaseURLProtocol.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/05.
//

import Foundation

protocol APIBaseURLProtocol {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    
    func makeURL() -> URL?
}

extension APIBaseURLProtocol {
    func makeURL() -> URL? {
        return URL(string: scheme + host + path)
    }
}
