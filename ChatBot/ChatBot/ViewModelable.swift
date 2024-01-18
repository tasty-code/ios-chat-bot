//
//  ViewModelable.swift
//  ChatBot
//
//  Created by 김준성 on 1/18/24.
//

import Combine

protocol ViewModelable {
    associatedtype Input
    associatedtype Output
    
    func transform(from input: Input) -> AnyPublisher<Output, Never>
}
