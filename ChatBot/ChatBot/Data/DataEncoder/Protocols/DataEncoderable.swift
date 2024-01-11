//
//  DataEncoderable.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

protocol DataEncoderable {
    func encodeType<T: Encodable>(_ object: T) throws -> Data
}
