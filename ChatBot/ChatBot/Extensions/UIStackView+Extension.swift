//
//  UIStackView+Extension.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/16/24.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}
