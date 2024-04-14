//
//  UIViewController+.swift
//  ChatBot
//
//  Created by 강창현 on 4/14/24.
//

import UIKit

extension UIViewController {
  func setupKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillHide),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
    addKeyboardGesture()
  }
  
  private func addKeyboardGesture() {
    let tapGestureRecognizer = UITapGestureRecognizer(
      target: self,
      action: #selector(dismissKeyboard)
    )
    view.addGestureRecognizer(tapGestureRecognizer)
  }
  
  @objc
  private func dismissKeyboard() {
    view.endEditing(true)
  }
  
  @objc
  private func keyboardWillShow(notification: NSNotification) {
    guard
      let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else {
      return
    }
    
    self.view.frame.size.height -= keyboardSize.height
  }
  
  @objc
  private func keyboardWillHide(notification: NSNotification) {
    guard
      let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
    else {
      return
    }
    
    self.view.frame.size.height += keyboardSize.height
  }
}
