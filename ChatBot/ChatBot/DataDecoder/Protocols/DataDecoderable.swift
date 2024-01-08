//
//  DataDecoderProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Foundation

protocol DataDecoderable {
    func decodeData<T: Decodable>(_ data: Data, to type: T.Type) throws -> T
}
