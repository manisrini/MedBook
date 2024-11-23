//
//  BookMarksListViewModel.swift
//  MedBook
//
//  Created by Manikandan on 23/11/24.
//

class BookMarksListViewModel{
    
    var bookMarks : [MedBook] = []
    var dataManager: HomeScreenDataManager
    
    init(dataManager: HomeScreenDataManager) {
        self.dataManager = dataManager
    }
    
    func fetchBookMarks(){
        self.bookMarks = dataManager.fetchBookMarksFromLocalDB()
    }
    
    func removeBookMarkFromDB(for id : Int){
        dataManager.deleteBookmark(byId: id) { _ in

        }
    }
}
