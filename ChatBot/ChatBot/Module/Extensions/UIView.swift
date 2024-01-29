//
//  UIView.swift
//  ChatBot
//
//  Created by Janine on 1/19/24.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
