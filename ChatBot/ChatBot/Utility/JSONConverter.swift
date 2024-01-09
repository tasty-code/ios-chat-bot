//
//  JSONConverter.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/05.
//

import Foundation

struct JSONConverter {
    static func encode<T: Encodable>(data: T) -> Data? {
        let encoder = JSONEncoder()
        let encodedData = try? encoder.encode(data)
        
        return encodedData
    }
    
    static func decode<T: Decodable>(type: T.Type, data: Data) -> T? {
        let decoder = JSONDecoder()
        let decodedData = try? decoder.decode(type, from: data)
        
        return decodedData
    }
}
