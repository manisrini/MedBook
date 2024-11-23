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

struct MedBook{
    let id : Int
    let title : String
    let ratings_average : Double
    let ratings_count : Int
    let author_name : String
    let imageUrl : String?
    var isBookMarked : Bool
    
    init(id: Int, title: String, ratings_average: Double, ratings_count: Int, author_name: String, imageUrl: String?, isBookMarked: Bool = false) {
        self.id = id
        self.title = title
        self.ratings_average = ratings_average
        self.ratings_count = ratings_count
        self.author_name = author_name
        self.imageUrl = imageUrl
        self.isBookMarked = isBookMarked
    }
}

class HomeScreenViewModel{
    
    var medBooks : [MedBook] = []
    var searchText : String = ""
    var searchLimit : Int = 10
    var showSortView : Bool = false
        
    func fetchBooks(dataManager : HomeScreenDataManager,completion : @escaping([MedBook],String?) -> Void){
        
        self.fetchBooksFromServer(dataManager: dataManager) { books in
            
            let medBooks = self.createMedBooks(books: books)
            self.medBooks.append(contentsOf: medBooks)
            completion(medBooks,nil)
        }
    }
    
    func fetchBooksFromServer(dataManager : HomeScreenDataManager,completion : @escaping([Book]) -> Void){
        Task{
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
    
    func saveBookMarkStatus(for index : Int,dataManager : HomeScreenDataManager){
        // Toggle bookmark status in the ViewModel
        self.medBooks[index].isBookMarked.toggle()
        
        dataManager.saveBookMark(book: self.medBooks[index], completionHandler: { result in
            
        })
    }

    private func createMedBooks(books : [Book]) -> [MedBook]{
        
        var tempBooks : [MedBook] = []
        
        for book in books {
            let imageUrl = "https://covers.openlibrary.org/b/id/\(book.cover_i)-M.jpg"
            tempBooks.append(
                .init(
                    id: book.cover_i,
                    title: book.title,
                    ratings_average: book.ratings_average,
                    ratings_count: book.ratings_count,
                    author_name: book.author_name.first ?? "",
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
