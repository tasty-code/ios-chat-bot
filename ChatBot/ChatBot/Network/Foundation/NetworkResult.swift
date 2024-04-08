//
//  NetworkResult.swift
//  ChatBot
//
//  Created by EUNJU on 3/28/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T)
    case requestErr
    case serverErr
    case networkFail
    case parsingErr
}
