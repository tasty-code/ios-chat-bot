//
//  PromptSetting+CoreDataProperties.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//
//

import Foundation
import CoreData


extension PromptSetting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PromptSetting> {
        return NSFetchRequest<PromptSetting>(entityName: "PromptSetting")
    }

    @NSManaged public var content: String?
    @NSManaged public var role: String?
    @NSManaged public var id: UUID?
    @NSManaged public var chatRoom: ChatRoom?

}

extension PromptSetting : Identifiable {

}
