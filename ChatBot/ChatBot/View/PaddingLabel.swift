//
//  PaddingLabel.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import UIKit

extension UILabel {
    func makePaddingLabel(padding: UIEdgeInsets) {
        
    }
    
    convenience init(frame: CGRect, padding: UIEdgeInsets) {
        self.init(frame: frame)
        
//        func drawText(in rect: CGRect) {
//
//        }
        drawText(in: frame.inset(by: padding))
        
        var intrinsicContentSize: CGSize {
            let size = self.intrinsicContentSize
            return CGSize(width: size.width + padding.left + padding.right, height: size.height + padding.top + padding.bottom)
        }
    }
}
