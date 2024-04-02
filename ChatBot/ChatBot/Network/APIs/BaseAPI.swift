//
//  BaseAPI.swift
//  ChatBot
//
//  Created by EUNJU on 3/29/24.
//

import Foundation

protocol BaseAPI: TargetType {
    var urlPath: String { get }
}

extension BaseAPI {
    var baseURL: String {
        return APIConstants.baseURL
    }
    
    var path: String {
        return urlPath
    }
    
    var header: HeaderType {
        return .basic
    }
}
