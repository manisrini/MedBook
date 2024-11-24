//
//  BookMarksListViewModel.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//

import DataBase
import Foundation

@MainActor
class BookMarksListViewModel{
    
    var bookMarks : [BookMarks] = []
    
    func fetchBookMarks(completion : @escaping() -> Void){
        let dbManager = DatabaseManager.shared
        if let loggedInUserId = UserDataHelper.getLoggedInUserId(dbManager: dbManager){
         BookMarkDataHelper.fetchBookmarks(dbManager: dbManager, userId: loggedInUserId,completionHandler: { result in
                switch result {
                case .success(let books):
                    self.bookMarks = books
                    completion()
                case .failure(_):
                    self.bookMarks = []
                    completion()
                }
            })
        }
    }
    
    func removeBookMarkFromDB(for id : UUID,completion : @escaping(Bool) -> Void){
        let dbManager = DatabaseManager.shared
        
        if let loggedInUserId = UserDataHelper.getLoggedInUserId(dbManager: dbManager){
            BookMarkDataHelper.deleteBookmark(dbManager: dbManager, userId: loggedInUserId, bookmarkId: id) { result in
                switch result {
                case .success(let success):
                    completion(success)
                case .failure(_):
                    completion(false)
                }
            }
        }
    }
}
