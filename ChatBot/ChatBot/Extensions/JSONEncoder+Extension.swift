//
//  JSONEncoder+Extension.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/19/24.
//

import Foundation

extension JSONEncoder: DataEncodable {
    func encode<T: Encodable>(from value: T) throws -> Data {
        guard let data = try? self.encode(value)
        else {
            throw APIError.failedEncoding
        }
        return data
    }
}
