//
//  Encoder.swift
//  ChatBot
//
//  Created by 김경록 on 1/8/24.
//

import Foundation

struct Encoder {
    private let encoder = JSONEncoder()
    
    func transformData(_ content: Encodable) throws -> Data? {
        guard let encodedData = try? encoder.encode(content) else {
            throw NetworkingError.codableError(whichTranform: "\(content) 인코딩")
        }
        
        return encodedData
    }
}
