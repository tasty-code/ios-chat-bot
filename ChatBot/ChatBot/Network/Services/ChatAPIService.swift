//
//  ChatAPIService.swift
//  ChatBot
//
//  Created by EUNJU on 4/1/24.
//

import Foundation

import Alamofire
import RxAlamofire
import RxSwift

final class ChatAPIService {
    
    typealias API = ChatAPI
    
    private let provider = NetworkProvider<API>()
    
    func createChat(systemContent: String, userContent: String) -> Single<ChatResponseModel?> {
        return provider.request(.createChat(systemContent: systemContent, userContent: userContent))
            .flatMap { dataRequest in
                return Single.create { single in
                    dataRequest.responseDecodable(of: ChatResponseModel.self) { response in
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
