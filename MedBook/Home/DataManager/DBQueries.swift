//
//  DBQueries.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//

import Foundation

class DBQueries {
    public static func filterBy(bookId : Int) -> NSPredicate
    {
        return NSPredicate(format: "id == %d",bookId)
    }
}
