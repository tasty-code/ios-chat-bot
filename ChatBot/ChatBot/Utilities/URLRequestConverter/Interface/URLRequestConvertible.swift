//
//  URLRequestConvertible.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/08.
//

import Foundation

protocol URLRequestConvertible {
    func asURLRequest(with encoder: JSONEncodable) throws -> URLRequest
}
