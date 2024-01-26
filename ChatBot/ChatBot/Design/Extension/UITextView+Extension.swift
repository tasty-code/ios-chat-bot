//
//  UITextView+Extension.swift
//  ChatBot
//
//  Created by 김준성 on 1/25/24.
//

import Foundation
import UIKit

extension UITextView {
    func addDoneButton(title: String, target: Any?, selctor: Selector) {
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: title, style: .done, target: target, action: selctor)
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: .max, height: .max))
        toolBar.setItems([flexible, doneButton], animated: false)
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
    }
}
