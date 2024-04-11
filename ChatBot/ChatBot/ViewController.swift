//
//  ViewController.swift
//  ChatBot
//
//  Created by Tacocat on 1/1/24.
//

import SnapKit
import Then
import UIKit

class ViewController: UIViewController {
    
    let chatBubbleView = ChatBubbleView()
    let chatLoadingIndicator = ChatLoadingIndicator()
    
    let button = UIButton(type: .roundedRect)
    var isUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        configureChatBubbleView()
        
        view.addSubview(chatLoadingIndicator)

        chatLoadingIndicator.snp.makeConstraints {
            $0.leading.equalTo(view.snp.leading)
            $0.centerY.equalTo(view.snp.centerY).inset(30)
        }
        
        view.addSubview(button)
        button.backgroundColor = .systemBlue
        button.snp.makeConstraints {
            $0.center.equalTo(view.center)
        }
        tapButton()
    }
    
    @objc func tapButton() {
        let text = "안녕하세요!"
        let text2 = "만약에 이 문장이 엄청나게 길어진다면 어떤 변화를 가져오게 될지 과연 짐작이나 되실런지요."
        
        isUser.toggle()
        chatBubbleView.setUser(isUser)
        chatBubbleView.setText(text)
        configureChatBubbleViewSide(isUser)
    }
}

extension ViewController {
    private func configureChatBubbleView() {
        view.addSubview(chatBubbleView)
        
        chatBubbleView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.7).priority(.high)
            $0.trailing.equalTo(view.snp.trailing).inset(10)
        }
    }
    
    private func configureChatBubbleViewSide(_ isUser: Bool) {
        chatBubbleView.setUser(isUser)
        chatBubbleView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.lessThanOrEqualTo(view.snp.width).multipliedBy(0.7).priority(.high)
            if isUser {
                $0.trailing.equalTo(view.snp.trailing).inset(10)
            } else {
                $0.leading.equalTo(view.snp.leading).inset(10)
            }
        }
    }
}
