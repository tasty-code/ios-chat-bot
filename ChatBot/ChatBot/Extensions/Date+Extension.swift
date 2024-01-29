//
//  Date+Extension.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//

import Foundation

extension Date {
    static let dateFormatter = DateFormatter()
    
    var toString: String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd(E) HH:mm"
        Date.dateFormatter.locale = Locale(identifier: "ko-KR")
        return Date.dateFormatter.string(from: self)
    }
}
