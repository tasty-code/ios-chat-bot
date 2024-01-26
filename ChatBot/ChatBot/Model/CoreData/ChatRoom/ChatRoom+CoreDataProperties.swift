//
//  ChatRoom+CoreDataProperties.swift
//  ChatBot
//
//  Created by 김준성 on 1/24/24.
//
//

import Foundation
import CoreData


extension ChatRoom {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatRoom> {
        return NSFetchRequest<ChatRoom>(entityName: "ChatRoom")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var recentChatDate: Date?
    @NSManaged public var title: String?
    @NSManaged public var chattings: NSSet?
    @NSManaged public var promptSetting: PromptSetting?

}

// MARK: Generated accessors for chattings
extension ChatRoom {

    @objc(addChattingsObject:)
    @NSManaged public func addToChattings(_ value: Chatting)

    @objc(removeChattingsObject:)
    @NSManaged public func removeFromChattings(_ value: Chatting)

    @objc(addChattings:)
    @NSManaged public func addToChattings(_ values: NSSet)

    @objc(removeChattings:)
    @NSManaged public func removeFromChattings(_ values: NSSet)

}

extension ChatRoom : Identifiable {

}
