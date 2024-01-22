//
//  JSONDecoder+Extension.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/19/24.
//

import Foundation

extension JSONDecoder: DataDecodable {
    func decode<T: Decodable>(to type: T.Type, from data: Data) throws -> T {
        guard let decodedData = try? self.decode(type, from: data)
        else {
            throw APIError.failedDecoding
        }
        return decodedData
    }
}
