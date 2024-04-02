//
//  Bundle+Extension.swift
//  ChatBot
//
//  Created by LeeSeongYeon on 3/26/24.
//

import Foundation

extension Bundle {
    var chatApi: String {
        guard
            let file = self.path(forResource: "APIToken", ofType: "plist"),
            let resource = NSDictionary(contentsOfFile: file),
            let key = resource["API_Token"] as? String
        else {
            return ""
        }
        return key
    }
}
