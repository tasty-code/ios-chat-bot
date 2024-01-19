//
//  ChatRoom+CoreDataProperties.swift
//  ChatBot
//
//  Created by 김준성 on 1/19/24.
//
//

import Foundation
import CoreData


extension ChatRoom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoom> {
        return NSFetchRequest<ChatRoom>(entityName: "ChatRoom")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var recentChatDate: Date?

}

extension ChatRoom : Identifiable {

}
