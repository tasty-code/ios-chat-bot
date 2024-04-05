//
//  Network.swift
//  ChatBot
//
//  Created by Matthew on 4/4/24.
//

import RxSwift
import RxAlamofire
import Foundation

class Network<T: Decodable> {
    private let queue: ConcurrentDispatchQueueScheduler
    
    init() {
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func fetchData(message: Message) -> Observable<T> {
        let urlRequest = NetworkURL.makeURLRequest(type: .chatGPT, chat: RequestChatDTO(messages: [message]), httpMethod: .post)!
        let result = RxAlamofire.requestData(urlRequest)
            .observe(on: queue)
            .debug()
            .map { (response, data) -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
        return result
    }
}
