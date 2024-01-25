//
//  GPTChattingVMProtocol.swift
//  ChatBot
//
//  Created by 김준성 on 1/11/24.
//

import Combine

typealias GPTChattingVMProtocol = GPTChattingsInputProtocol & GPTChattingOutputProtocol

protocol GPTChattingsInputProtocol {
    func onViewDidLoad()
    func onViewWillAppear()
    func onViewWillDisappear()
    func sendChat(_ content: String?)
}

protocol GPTChattingOutputProtocol {
    var updateChattings: AnyPublisher<(messages: [Model.GPTMessage], indexToUpdate: Int), Never> { get }
    var error: AnyPublisher<Error, Never> { get }
}
