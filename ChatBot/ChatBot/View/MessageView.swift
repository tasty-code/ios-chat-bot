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
  
  override func drawText(in rect: CGRect) {
    let insets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    super.drawText(in: rect.inset(by: insets))
  }
  
  private func configureUI() {
    self.text = "In the land of code, there lies a path.Where functions call themselves in wrath.It's recursion, a looping scheme.A mesmerizing, recursive dream.A function's call, within its own embrace.A cycle of enchanting grace.Like a mirror reflecting back its view.Each iteration is born anew.Through recursive calls, the task is done.A pattern spun, a code web spun.Like a never-ending dance of thought.The function's journey, never caught.In programming's realm, recursion thrives.A concept of looping that endlessly drives.A journey within, a tale untold.In the mystic, recursive code's stronghold.So embrace the recursion, don't be shy.Let your functions dance, let them fly.In programming's poetry, let them sing.The beauty of recursion, a majestic thingIn the land of code, there lies a path.Where functions call themselves in wrath.It's recursion, a looping scheme.A mesmerizing, recursive dream.A function's call, within its own embrace.A cycle of enchanting grace.Like a mirror reflecting back its view.Each iteration is born anew.Through recursive calls, the task is done.A pattern spun, a code web spun.Like a never-ending dance of thought.The function's journey, never caught.In programming's realm, recursion thrives."
    self.translatesAutoresizingMaskIntoConstraints = false
    self.backgroundColor = .clear
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
    
    if width >= UIScreen.main.bounds.width * 0.75 {
      width = UIScreen.main.bounds.width * 0.75
    }
  }
  
  private func setupConstraints() {
    NSLayoutConstraint.activate([
      self.widthAnchor.constraint(equalToConstant: width),
    ])
  }
}
