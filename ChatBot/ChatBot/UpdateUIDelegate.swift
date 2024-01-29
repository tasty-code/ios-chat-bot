//
//  UpdateUIDelegate.swift
//  ChatBot
//
//  Created by 김수경 on 2024/01/29.
//

import Foundation

protocol UpdateUIDelegate: AnyObject {
    func updateUI(message: [Message])
}
