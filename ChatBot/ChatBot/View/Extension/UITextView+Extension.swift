//
//  UITextView+Extension.swift
//  ChatBot
//
//  Created by JaeHyeok Sim on 1/22/24.
//

import UIKit

extension UITextView {
    var estimatedHeight: CGFloat {
        let size = CGSize(width: self.frame.width, height: .infinity)
        let estimatedSize = self.sizeThatFits(size)
        return estimatedSize.height
    }
}
