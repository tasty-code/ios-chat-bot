//
//  MessageView.swift
//  ChatBot
//
//  Created by Matthew on 4/11/24.
//

import UIKit
import Then
import SnapKit

final class MessageView: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Method
private extension MessageView {
    func configureUI() {
        self.tintColor = .black
        self.backgroundColor = .clear
        self.textAlignment = .left
        self.numberOfLines = 0
    }
}
