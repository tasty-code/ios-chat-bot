//
//  NetworkManagerProtocol.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/05.
//

import Foundation

protocol NetworkManagerProtocol {
    func getData(body: Data?) async throws -> Data
}
