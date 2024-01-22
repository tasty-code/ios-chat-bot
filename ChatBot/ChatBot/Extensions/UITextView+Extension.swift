//
//  UITextView+Extension.swift
//  ChatBot
//
//  Created by 김진웅 on 1/11/24.
//

import UIKit

extension UITextView {
    var estimatedSizeHeight: CGFloat {
        let size = CGSize(width: self.frame.size.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        return estimatedSize.height
    }
}
