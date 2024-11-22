//
//  MedBookData+CoreDataProperties.swift
//  MedBook
//
//  Created by Manikandan on 22/11/24.
//
//

import Foundation
import CoreData


extension MedBookData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MedBookData> {
        return NSFetchRequest<MedBookData>(entityName: "MedBookData")
    }

    @NSManaged public var title: String?
    @NSManaged public var ratings_avg: Float
    @NSManaged public var ratings_count: Int64
    @NSManaged public var author_name: String?
    @NSManaged public var isBookMarked: Bool
    @NSManaged public var imageUrl: String?
    @NSManaged public var id: Int64

}

extension MedBookData : Identifiable {

}
