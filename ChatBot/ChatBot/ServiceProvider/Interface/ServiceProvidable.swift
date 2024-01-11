//
//  ServiceProvidable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

protocol ServiceProvidable {
    associatedtype E: Encodable
    associatedtype D: Decodable
    
    func excute(for requestDTO: E) async throws -> D
}
