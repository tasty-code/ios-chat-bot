//
//  URLSessionProtocol.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/10/24.
//

import Foundation

protocol URLSessionProtocol {
    func dataTask(with url: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask
}
