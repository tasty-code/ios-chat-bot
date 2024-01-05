//
//  RequestData.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/3/24.
//
import Foundation

// MARK: - RequestData
struct RequestData: Encodable {
    let model: String = "gpt-3.5-turbo-1106"
    let messages: [Message]
}
