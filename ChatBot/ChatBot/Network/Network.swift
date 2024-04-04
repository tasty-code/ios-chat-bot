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
    private let urlRequest: URLRequest
    private let queue: ConcurrentDispatchQueueScheduler
    
    init(_ urlRequst: URLRequest) {
        self.urlRequest = urlRequst
        self.queue = ConcurrentDispatchQueueScheduler(qos: .background)
    }
    
    func fetchData() -> Observable<T> {
        RxAlamofire.requestData(urlRequest)
            .observeOn(queue)
            .debug()
            .map { (response, data) -> T in
                return try JSONDecoder().decode(T.self, from: data)
            }
    }
}
