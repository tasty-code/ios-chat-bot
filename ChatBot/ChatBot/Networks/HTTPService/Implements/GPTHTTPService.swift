//
//  HTTPService.swift
//  ChatBot
//
//  Created by 김준성 on 1/8/24.
//

import Combine
import Foundation

extension Network {
    final class GPTHTTPService: HTTPServicable {
        let publisher: HTTPPublishable
        let encoder: DataEncoderable
        let decoder: DataDecoderable
        
        init(publisher: HTTPPublishable = URLSession.shared, encoder: DataEncoderable, decoder: DataDecoderable) {
            self.publisher = publisher
            self.encoder = encoder
            self.decoder = decoder
        }
        
        func request<D: Decodable>(request: HTTPRequestable, type: D.Type) -> AnyPublisher<D, Error> {
            do {
                let request = try request.asURLRequest()
                return publisher.publish(urlRequest: request)
                    .tryMap { try self.decoder.decodeData($0, to: D.self) }
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
        
        func request<E: Encodable, D: Decodable>(request: HTTPRequestable, object: E, type: D.Type) -> AnyPublisher<D, Error> {
            do {
                var request = try request.asURLRequest()
                let data = try encoder.encodeType(object)
                request.httpBody = data
                return publisher.publish(urlRequest: request)
                    .tryMap { try self.decoder.decodeData($0, to: type.self) }
                    .eraseToAnyPublisher()
            } catch {
                return Fail(error: error).eraseToAnyPublisher()
            }
        }
    }
}
