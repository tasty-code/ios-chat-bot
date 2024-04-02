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
    
    func request(
        _ api: API,
        file: StaticString,
        function: StaticString, line: UInt
    ) -> Single<DataRequest>
}

final class NetworkProvider<API: BaseAPI>: Requestable {
    
    func request(
        _ api: API,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> Single<DataRequest> {
        return AF.rx.request(urlRequest: api)
            .asSingle()
    }
}
