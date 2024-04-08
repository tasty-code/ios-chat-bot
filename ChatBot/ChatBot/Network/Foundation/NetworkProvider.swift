//
//  NetworkProvider.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Alamofire
import RxAlamofire
import RxSwift

protocol Requestable {
    associatedtype API: BaseAPI
    
    func request<T: Decodable>(
        _ api: API,
        file: StaticString,
        function: StaticString, line: UInt
    ) -> Single<T>
}

final class NetworkProvider<API: BaseAPI>: Requestable {
    
    func request<T: Decodable>(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<T> {
        AF.rx.request(urlRequest: api)
            .asSingle()
            .flatMap { dataRequest in
                Single.create { single in
                    dataRequest.responseDecodable(of: T.self) { response in
                        switch response.result {
                        case .success(let model):
                            single(.success(model))
                        case .failure(let error):
                            single(.failure(error))
                        }
                    }
                    return Disposables.create()
                }
            }
    }
}
