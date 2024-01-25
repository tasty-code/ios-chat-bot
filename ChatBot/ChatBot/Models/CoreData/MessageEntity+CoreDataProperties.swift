//
//  MessageEntity+CoreDataProperties.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//
//

import Foundation
import CoreData


extension MessageEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageEntity> {
        return NSFetchRequest<MessageEntity>(entityName: "MessageEntity")
    }

    @NSManaged public var content: String?
    @NSManaged public var role: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var date: Date?
    @NSManaged public var roomRelationship: RoomEntity?

}

extension MessageEntity : Identifiable {

}
