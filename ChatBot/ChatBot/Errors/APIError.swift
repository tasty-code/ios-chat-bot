//
//  APIError.swift
//  ChatBot
//
//  Created by 동준 on 1/5/24.
//

import Foundation

enum APIError: Error {
    case URLError
    case unableToCreateURLForURLRequest
}
