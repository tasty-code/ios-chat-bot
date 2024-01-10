//
//  HTTPPublishable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Combine
import Foundation

protocol HTTPPublishable {
    func responsePublisher(urlRequest: URLRequest) -> AnyPublisher<Data, GPTError.HTTPError>
}
