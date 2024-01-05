//
//  NetworkBuilderProtocol.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

protocol NetworkBuilderProtocol {
    var method: String { get }
    var path: String { get }
    var header: [String: String] { get }
    var body: Data {get}
}
