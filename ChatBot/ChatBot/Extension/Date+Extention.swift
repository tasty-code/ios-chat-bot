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
    
    func toLocaleString(_ localeCode: Date.LocaleCode) -> String {
        let dateFomatter = DateFormatter()
        dateFomatter.locale = Locale(identifier: localeCode.rawValue)
        dateFomatter.setLocalizedDateFormatFromTemplate("yyyy MMM dd hh mm")
        return dateFomatter.string(from: self)
    }
}

extension Date {
    enum LocaleCode: String {
        case koKR = "ko_KR"
    }
}
