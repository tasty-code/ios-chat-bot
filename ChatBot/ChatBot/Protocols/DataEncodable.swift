//
//  DataEncodable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/19/24.
//

import Foundation

protocol DataEncodable {
    func encode<T: Encodable>(from value: T) throws -> Data
}
