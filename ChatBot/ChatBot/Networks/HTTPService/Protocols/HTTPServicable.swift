//
//  HTTPServicable.swift
//  ChatBot
//
//  Created by 김준성 on 1/9/24.
//

import Combine
import Foundation

protocol HTTPServicable {
    func request<D: Decodable>(request: HTTPRequestable, type: D.Type) -> AnyPublisher<D, Error>
    func request<E: Encodable, D: Decodable>(request: HTTPRequestable, object: E, type: D.Type) -> AnyPublisher<D, Error>
}
