//
//  SystemBubbleView.swift
//  ChatBot
//
//  Created by Matthew on 4/12/24.
//

import UIKit
import Then
import SnapKit

final class SystemBubbleView: ChatBubbleView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentMode = .redraw
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Public Method
extension SystemBubbleView {
    override func draw(_ rect: CGRect) {
        setLeftBubbleView(rect: rect)
    }
}
