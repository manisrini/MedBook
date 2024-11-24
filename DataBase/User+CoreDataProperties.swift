//
//  User+CoreDataProperties.swift
//  MedBook
//
//  Created by Manikandan on 24/11/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var country: String?
    @NSManaged public var email: String?
    @NSManaged public var id: UUID?
    @NSManaged public var isLoggedIn: Bool
    @NSManaged public var password: String?
    @NSManaged public var bookMarks: NSSet?

}

// MARK: Generated accessors for bookMarks
extension User {

    @objc(addBookMarksObject:)
    @NSManaged public func addToBookMarks(_ value: BookMarks)

    @objc(removeBookMarksObject:)
    @NSManaged public func removeFromBookMarks(_ value: BookMarks)

    @objc(addBookMarks:)
    @NSManaged public func addToBookMarks(_ values: NSSet)

    @objc(removeBookMarks:)
    @NSManaged public func removeFromBookMarks(_ values: NSSet)

}
