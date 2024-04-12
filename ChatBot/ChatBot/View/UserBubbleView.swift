//
//  UserBubbleView.swift
//  ChatBot
//
//  Created by Matthew on 4/12/24.
//

import UIKit
import Then
import SnapKit

final class UserBubbleView: ChatBubbleView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Method
extension UserBubbleView {
    override func draw(_ rect: CGRect) {
        setRightBubbleView(rect: rect)
    }
}
