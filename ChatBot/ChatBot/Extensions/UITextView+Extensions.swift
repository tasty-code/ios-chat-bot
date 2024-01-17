//
//  UITextView+Extensions.swift
//  ChatBot
//
//  Created by Wonji Ha on 1/16/24.
//

import UIKit

extension UITextView {
    var estimatedSizeHeight: CGFloat {
        let size = CGSize(width: self.frame.size.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        return estimatedSize.height
    }
}
