//
//  UIView++Extension.swift
//  ChatBot
//
//  Created by 전성수 on 1/24/24.
//

import UIKit

extension UIView {
    
    // MARK: - for cricle uiView

    convenience init(backgroundColor: UIColor, cornerRadius: CGFloat) {
        self.init()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = backgroundColor
        self.layer.cornerRadius = cornerRadius / 2
    }
}
