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
    
    let button = UIButton(type: .roundedRect)
    var isUser: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        button.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        configureChatBubbleView()
        
        view.addSubview(button)
        button.backgroundColor = .systemBlue
        button.snp.makeConstraints {
            $0.center.equalTo(view.center)
        }
        tapButton()
    }
    
    @objc func tapButton() {
        let text = "안녕하세요! 글이 길더라도 일정한 길이를 유지하면서 방향만 바뀌도록 구현해 보았습니다. 이정도면 이제 충분히 값을 잘 담아줄 수 있는 것 같네요."
        
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
            $0.width.equalTo(view.snp.width).multipliedBy(0.65)
            $0.leading.equalTo(view.snp.leading).inset(10)
        }
    }
    
    private func configureChatBubbleViewSide(_ isUser: Bool) {
        print(isUser)
        chatBubbleView.setUser(isUser)
        chatBubbleView.snp.remakeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            $0.width.equalTo(view.snp.width).multipliedBy(0.65)
            if isUser {
                $0.leading.equalTo(view.snp.leading).inset(10)
            } else {
                $0.trailing.equalTo(view.snp.trailing).inset(10)
            }
        }
    }
}
