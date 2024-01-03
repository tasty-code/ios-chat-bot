//
//  Bundle+Extension.swift
//  ChatBot
//
//  Created by 김진웅 on 1/3/24.
//

import Foundation

extension Bundle {
    var gptAPIKey: String? {
        guard let file = self.path(forResource: "APIKeys", ofType: "plist"),
              let resource = NSDictionary(contentsOf: URL(fileURLWithPath: file)),
              let key = resource["GPTAPI"] as? String
        else {
            return nil
        }
        return key
    }
}
