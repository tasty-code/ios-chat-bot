//
//  JSONCodable.swift
//  ChatBot
//
//  Created by 김진웅 on 1/9/24.
//

import Foundation

typealias JSONCodable = JSONEncodable & JSONDecodable

protocol JSONEncodable {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

protocol JSONDecodable {
    func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T
}
