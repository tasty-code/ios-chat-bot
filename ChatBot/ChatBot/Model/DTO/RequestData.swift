//
//  RequestData.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/3/24.
//
import Foundation

// MARK: - RequestData
struct RequestData: Decodable {
    let model: String
    let messages: [Message]
}

