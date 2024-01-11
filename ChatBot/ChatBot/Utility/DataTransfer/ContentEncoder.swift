//
//  ContentEncoder.swift
//  ChatBot
//
//  Created by 김경록 on 1/8/24.
//

import Foundation

struct ContentEncoder {
    var encoder = JSONEncoder()
    
    func transformData(_ content: Encodable) -> Data? {
        guard let encodedData = try? encoder.encode(content) else {
            return nil
        }
        
        return encodedData
    }
}
