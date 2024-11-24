//
//  Countries+CoreDataProperties.swift
//  MedBook
//
//  Created by Manikandan on 24/11/24.
//
//

import Foundation
import CoreData


extension Countries {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Countries> {
        return NSFetchRequest<Countries>(entityName: "Countries")
    }

    @NSManaged public var name: String?
    @NSManaged public var code: String?

}
