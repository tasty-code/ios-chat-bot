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
    @NSManaged public var chatList: NSSet?

}

// MARK: Generated accessors for chatList
extension ChatRoom {

    @objc(addChatListObject:)
    @NSManaged public func addToChatList(_ value: Chatting)

    @objc(removeChatListObject:)
    @NSManaged public func removeFromChatList(_ value: Chatting)

    @objc(addChatList:)
    @NSManaged public func addToChatList(_ values: NSSet)

    @objc(removeChatList:)
    @NSManaged public func removeFromChatList(_ values: NSSet)

}

extension ChatRoom : Identifiable {

}
