//
//  MessageContentConfiguration.swift
//  ChatBot
//
//  Created by 김진웅 on 1/12/24.
//

import UIKit

struct MessageContentConfiguration: UIContentConfiguration {
    var message: ChatMessage?
    
    func makeContentView() -> UIView & UIContentView {
        return MessageContentView(configuration: self)
    }
    
    func updated(for state: UIConfigurationState) -> MessageContentConfiguration {
        return self
    }
}
