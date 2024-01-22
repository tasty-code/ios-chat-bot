//
//  ServiceProvidable.swift
//  ChatBot
//
//  Created by BOMBSGIE on 2024/01/09.
//

import Foundation

protocol ServiceProvidable {
    func excute<E: APIEndPoint, D: ResponseDTODecodable>(for endPoint: E) async throws -> D
}
