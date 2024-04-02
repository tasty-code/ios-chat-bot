//
//  Config.swift
//  ChatBot
//
//  Created by EUNJU on 4/2/24.
//

import Foundation

enum Config {
    
    static var openAIAPIKey: String {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            assertionFailure("OPENAI_API_KEY could not found.")
            return ""
        }
        return key
    }
    
    static var baseURL: String {
        guard let url = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            assertionFailure("BASE_URL could not found.")
            return ""
        }
        return url
    }
}
