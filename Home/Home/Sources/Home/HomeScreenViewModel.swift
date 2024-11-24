//
//  HomeScreenViewModel.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

import NetworkManager
import Foundation
import Utilities
import DesignSystem
import DataBase


@MainActor
class HomeScreenViewModel{
    
    var medBooks : [MedBook] = []
    var searchText : String = ""
    var searchLimit : Int = 10
    var showSortView : Bool = false
        
    
    func fetchBooks(isPagination : Bool = false,completion : @escaping([MedBook],String?) -> Void){
        
        
        self.fetchBooksFromServer{ books in
            
            let medBooks = self.createMedBooks(books: books)
            if isPagination{
                self.medBooks.append(contentsOf: medBooks)
            }else{
                self.medBooks = medBooks
            }
            completion(medBooks,nil)
        }
    }
    
    func fetchBooksFromServer(completion : @escaping([Book]) -> Void){
        Task {
            let url = "https://openlibrary.org/search.json?title=\(self.searchText)&limit=\(self.searchLimit)&offset=\(self.medBooks.count)"
            print(url)
            let (data, _) = await NetworkManager.shared.getData(urlStr: url)
                
            guard let _data = data else{ return }

            do{
                let decoder = JSONDecoder()
                let books = try decoder.decode(BooksResponse.self, from: _data)
                completion(books.docs)
            }catch {
                completion([])
            }
        }
    }
    
    func saveBookMarkStatus(for index : Int,dataManager : HomeScreenDataHelper){
        // Toggle bookmark status in the ViewModel
        self.medBooks[index].isBookMarked.toggle()
        let bookMarkDetails = self.medBooks[index]
        
        let dbManager = DatabaseManager.shared
        if let loggedInUserId = UserDataHelper.getLoggedInUserId(dbManager: dbManager){
            
            BookMarkDataHelper.addBookmark(dbManager: dbManager, userId: loggedInUserId, bookmarkDetails: bookMarkDetails) { result in
                
            }
        }
        
    }

    private func createMedBooks(books : [Book]) -> [MedBook]{
        
        var tempBooks : [MedBook] = []
        
        for book in books {
            let cover_i = book.cover_i ?? 0
            let imageUrl = "https://covers.openlibrary.org/b/id/\(cover_i)-M.jpg"
            tempBooks.append(
                .init(
                    title: book.title,
                    ratings_average: book.ratings_average ?? 0,
                    ratings_count: book.ratings_count ?? 0,
                    author_name: book.author_name?.first ?? "",
                    imageUrl: imageUrl
                )
            )
        }
        
        return tempBooks
    }
    
    func getCount() -> Int{
        if searchText.count >= 3{
            return medBooks.count
        }
        return 0
    }
    
    func canShowSortingView() -> Bool{
        if self.searchText.count >= 3{
            return true
        }
        return false
    }
    
    func sortBooks(using type : SortingType){
            
        self.medBooks.sort { prevOption, nextOption in
            switch type {
            case .Rating:
                prevOption.ratings_average > nextOption.ratings_average
            case .Title:
                prevOption.title < nextOption.title
            case .Hits:
                prevOption.ratings_count > nextOption.ratings_count
            }
        }
    }
    
    func bookMark(for book : MedBook){
        
    }
    
    func logoutUser(completion : @escaping(Bool) -> Void){
        UserDataHelper.logoutUser(dbManager: DatabaseManager.shared) { result in
            switch result {
            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
    
    ///Save data in database
//    private func saveData(dataManager : HomeScreenDataManager,books : [MedBook]){
//        
//        dataManager.save(books: books, completionHandler: { result in
//            switch result {
//            case .success(_):
//                print("books saved!!!")
//            case .failure(_):
//                print("books not saved!!!")
//            }
//        })
//    }

}
