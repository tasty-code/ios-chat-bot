//
//  UIAlertController+Extension.swift
//  ChatBot
//
//  Created by 김준성 on 1/22/24.
//

import Combine
import UIKit

extension UIAlertController {
    static func presentErrorPublisher(on viewController: UIViewController, with error: Error) -> AnyPublisher<Void, Never> {
        Future<Void, Never> { promise in
            let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)

            let okayAction = UIAlertAction(title: "Okay", style: .default) { _ in
                promise(.success(()))
            }
            
            alertController.addAction(okayAction)

            viewController.present(alertController, animated: true, completion: nil)
        }
        .eraseToAnyPublisher()
    }
    
    /// 에러를 보여주기 위해 사용합니다.
    convenience init(error: Error) {
        self.init(title: "\(type(of: error))", message: error.localizedDescription, preferredStyle: .alert)
        addAction(UIAlertAction(title: "닫기", style: .cancel))
    }
    
    /// 방의 제목을 입력받아 생성 또는 삭제하기 위해 사용합니다.
    convenience init(title: String, message: String?, completionHandler: @escaping (String?) -> Void) {
        self.init(title: title, message: message, preferredStyle: .alert)
        addTextField()
        addAction(UIAlertAction(title: "닫기", style: .destructive))
        addAction(UIAlertAction(title: "확인", style: .default, handler: { [weak self] _ in
            completionHandler(self?.textFields?.first?.text)
        }))
    }
}
