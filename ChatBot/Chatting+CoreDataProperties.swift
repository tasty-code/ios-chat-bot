//
//  Chatting+CoreDataProperties.swift
//  ChatBot
//
//  Created by 김준성 on 1/21/24.
//
//

import Foundation
import CoreData


extension Chatting {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chatting> {
        return NSFetchRequest<Chatting>(entityName: "Chatting")
    }

    @NSManaged public var content: String?
    @NSManaged public var id: UUID?
    @NSManaged public var role: String?
    @NSManaged public var chatRoom: ChatRoom?

}

extension Chatting : Identifiable {

}
