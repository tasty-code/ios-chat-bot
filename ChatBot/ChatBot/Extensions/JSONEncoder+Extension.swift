//
//  JSONEncoder+Extension.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/19/24.
//

import Foundation

extension JSONEncoder: DataEncodable {
    func encode<T>(from value: T) throws -> Data where T : Encodable {
        guard let data = try? self.encode(value)
        else {
            throw APIError.failedEncoding
        }
        return data
    }
}
