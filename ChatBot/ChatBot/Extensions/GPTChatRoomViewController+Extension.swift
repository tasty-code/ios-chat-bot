//
//  GPTChatRoomViewController.swift
//  ChatBot
//
//  Created by 김진웅 on 1/11/24.
//

import UIKit

extension GPTChatViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard textView.contentSize.height < view.frame.height * 0.15
        else {
            textView.isScrollEnabled = true
            return
        }
        
        textView.isScrollEnabled = false
        textView.constraints.forEach { constraint in
            guard constraint.firstAttribute != .height 
            else {
                constraint.constant = textView.estimatedSizeHeight
                return
            }
        }
    }
}
