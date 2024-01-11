//
//  JSONEecoder+DataEecoderable.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

extension JSONEncoder: DataEncoderable {
    func encodeType<T>(_ object: T) throws -> Data where T : Encodable {
        try self.encode(object)
    }
}
