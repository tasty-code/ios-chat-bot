//
//  RepositoryError.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//

import Foundation

extension GPTError {
    enum RepositoryError: Error {
        case contextNotFound
        case dataNotFound
        case dataAlreadyExsist
    }
}
