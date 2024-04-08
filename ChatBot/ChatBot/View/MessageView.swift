//
//  MessageView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/4.
//

import UIKit

final class MessageView: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    //    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //  override func drawText(in rect: CGRect) {
  //    let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
  //    super.drawText(in: rect.inset(by: insets))
  //  }
  
//  func setupSize() {
//    guard let text = self.text as? NSString else { return }
//    
//    let height = text.size(
//      withAttributes:
//        [
//          NSAttributedString.Key.font : self.font ?? .preferredFont(forTextStyle: .body)
//        ]
//    ).height
//    NSLayoutConstraint.activate([
//      self.heightAnchor.constraint(greaterThanOrEqualToConstant: height),
//    ])
//  }
}

private extension MessageView {
  func configureUI() {
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
    self.textAlignment = .left
    self.numberOfLines = 0
  }
  
  
  //  func setupConstraints() {
  //    NSLayoutConstraint.activate([
  //      self.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width * 0.75),
  //    ])
  //  }
}
