//
//  UIAlert+Extension.swift
//  ChatBot
//
//  Created by Matthew on 3/31/24.
//

import UIKit

extension UIViewController {
    func showMessageAlert(
        title: String? = nil,
        message: String,
        action: [UIAlertAction],
        completion: (() -> ())? = nil
    ) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for result in action {
            alertViewController.addAction(result)
        }
        
        self.present(alertViewController, animated: true, completion: completion)
    }
}
