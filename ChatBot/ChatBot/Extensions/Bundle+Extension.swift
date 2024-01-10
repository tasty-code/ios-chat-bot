//
//  Bundle+Extension.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/8/24.
//

import Foundation

extension Bundle {
    var apiKey: String?  {
        guard let filePath = self.path(forResource: "APIKey", ofType: "plist") else {
            debugPrint(APIKeyError.keyFileNotFound)
            return nil
        }
        
        let plist = NSDictionary(contentsOfFile: filePath)
        guard let key = plist?["Key"] as? String else {
            debugPrint(APIKeyError.keyNotFound)
            return nil
        }
        return key
    }
}
