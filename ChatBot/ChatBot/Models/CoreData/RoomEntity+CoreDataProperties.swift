//
//  RoomEntity+CoreDataProperties.swift
//  ChatBot
//
//  Created by BOMBSGIE on 1/25/24.
//
//

import Foundation
import CoreData


extension RoomEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RoomEntity> {
        return NSFetchRequest<RoomEntity>(entityName: "RoomEntity")
    }

    @NSManaged public var uuid: UUID?
    @NSManaged public var title: String?
    @NSManaged public var date: Date?
    @NSManaged public var messageRelationship: NSSet?

}

// MARK: Generated accessors for messageRelationship
extension RoomEntity {

    @objc(addMessageRelationshipObject:)
    @NSManaged public func addToMessageRelationship(_ value: MessageEntity)

    @objc(removeMessageRelationshipObject:)
    @NSManaged public func removeFromMessageRelationship(_ value: MessageEntity)

    @objc(addMessageRelationship:)
    @NSManaged public func addToMessageRelationship(_ values: NSSet)

    @objc(removeMessageRelationship:)
    @NSManaged public func removeFromMessageRelationship(_ values: NSSet)

}

extension RoomEntity : Identifiable {

}
