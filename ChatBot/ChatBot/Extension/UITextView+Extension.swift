//
//  UITextView+Extension.swift
//  ChatBot
//
//  Created by 최승범 on 2024/01/12.
//

import UIKit

extension UITextView {
    var estimatedSizeHeight: CGFloat {
        let size = CGSize(width: self.frame.size.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        return estimatedSize.height
    }
}
