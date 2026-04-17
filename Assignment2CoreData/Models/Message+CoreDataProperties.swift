//
//  Message+CoreDataProperties.swift
//  Assignment2CoreData
//
//  Created by James Faloon on 2026-04-17.
//
//

import Foundation
import CoreData


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }

    @NSManaged public var message: String?
    @NSManaged public var id: UUID?

}

extension Message : Identifiable {

}
