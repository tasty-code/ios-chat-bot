//
//  AppEnviroment.swift
//  ChatBot
//
//  Created by 김준성 on 1/17/24.
//

import Foundation

struct AppEnviroment {
    static let defaultHTTPSecvice = Network.GPTHTTPService(encoder: JSONEncoder(), decoder: JSONDecoder())
    static let defaultCDRepository = Repository.CoreDataRepository(containerName: "ChatBotCoreData")
}
