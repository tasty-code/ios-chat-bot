//
//  DataDecodable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/19/24.
//

import Foundation

protocol DataDecodable {
    func decode<T: Decodable>(to type: T.Type, from data: Data) throws -> T
}
