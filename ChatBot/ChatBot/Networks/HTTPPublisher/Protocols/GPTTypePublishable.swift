//
//  GPTTypePublishable.swift
//  ChatBot
//
//  Created by 김준성 on 1/5/24.
//

import Foundation
import Combine

protocol GPTTypePublishable {
    associatedtype T = Decodable
    
    var httpPublisher: HTTPPublishable { get }
    
    func map(_ data: Data) throws -> T
    func publish(urlRequest: URLRequest, errorHandler: (Error) -> Void) -> AnyPublisher<T, Never>
}
