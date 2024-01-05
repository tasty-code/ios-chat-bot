//
//  HTTPDecoratable.swift
//  ChatBot
//
//  Created by 김준성 on 1/4/24.
//

import Foundation

protocol HTTPDecoratable: HTTPRequestable {
    var httpRequest: HTTPRequestable { get }
}

extension HTTPDecoratable {
    var urlString: String? { nil }
}
