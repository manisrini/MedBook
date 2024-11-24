//
//  BookMarks+CoreDataProperties.swift
//  MedBook
//
//  Created by Manikandan on 24/11/24.
//
//

import Foundation
import CoreData


extension BookMarks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookMarks> {
        return NSFetchRequest<BookMarks>(entityName: "BookMarks")
    }

    @NSManaged public var author_name: String?
    @NSManaged public var id: UUID?
    @NSManaged public var imageUrl: String?
    @NSManaged public var ratings_avg: Double
    @NSManaged public var ratings_count: Int64
    @NSManaged public var title: String?
    @NSManaged public var user: User?

}
