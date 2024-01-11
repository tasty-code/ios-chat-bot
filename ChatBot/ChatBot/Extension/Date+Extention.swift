//
//  Date+Extention.swift
//  ChatBot
//
//  Created by 김준성 on 1/3/24.
//

import Foundation

extension Date {
    init(unixTimeStamp: UInt) {
        self.init(timeIntervalSince1970: TimeInterval(unixTimeStamp))
    }
}
