//
//  JSONDecoder+DataDecoderable.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

extension JSONDecoder: DataDecoderable {
    func decodeData<T>(_ data: Data, to type: T.Type) throws -> T where T : Decodable {
        try self.decode(T.self, from: data)
    }
}
