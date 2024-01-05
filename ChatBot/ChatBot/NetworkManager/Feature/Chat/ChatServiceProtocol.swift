//
//  ChatServiceProtocol.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/05.
//

import Foundation

protocol ChatServiceProtocol {
    func sendMessage(text: String, completion: @escaping (Result<ResponseData, Error>) -> Void) throws 
}
