//
//  PaddingLabel.swift
//  ChatBot
//
//  Created by Rarla on 2024/01/15.
//

import UIKit

final class PaddingLabel: UILabel {
    var padding: UIEdgeInsets

    override init(frame: CGRect) {
        self.padding = .zero
        super.init(frame: frame)
    }

    convenience init(inset: UIEdgeInsets) {
        self.init(frame: .zero)
        self.padding = inset
    }

    required init?(coder: NSCoder) {
        self.padding = .zero
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + padding.left + padding.right, height: size.height + padding.top + padding.bottom)
    }
}

