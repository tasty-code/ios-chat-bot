//
//  MessageView.swift
//  ChatBot
//
//  Created by 이보한 on 2024/4/4.
//

import UIKit

final class MessageView: UILabel {
  private var width: Double = 0.0
  private var height: Double = 0.0
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
    setupSize()
    setupConstraints()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureUI() {
    self.text = ""
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .white
    self.textAlignment = .left
    self.numberOfLines = 0
  }
  
  private func setupSize() {
    guard let text = self.text as? NSString else { return }

    width = text.size(
      withAttributes: [
        NSAttributedString.Key.font : self.font ?? .preferredFont(forTextStyle: .body)
      ]
    ).width
    
    if width >= 150 {
      width = 150
    }
    
    height = text.size(
      withAttributes: [
        NSAttributedString.Key.font : self.font ?? .preferredFont(forTextStyle: .body)
      ]
    ).height
    
    if width >= 150 {
      height = CGFloat(Int(height) + self.numberOfLines * Int(height))
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.heightAnchor.constraint(equalToConstant: height),
      self.widthAnchor.constraint(equalToConstant: width),
    ])
  }
}
