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
    let isBookMarked : Bool = false
}

class HomeScreenViewModel{
    
    var medBooks : [MedBook] = []
    var searchText : String = ""
    var showSortView : Bool = false
    
    func fetchBooks(dataManager : HomeScreenDataManager,completion : @escaping(BooksResponse?,String?) -> Void){
        
        if dataManager.hasDataInDB(){
            print("Already in DB")
        }else{
            Task{
                let url = "https://openlibrary.org/search.json?title=game&limit=10"
                let (data, _) = await NetworkManager.shared.getData(urlStr: url)
                    
                guard let _data = data else{ return }

                do{
                    let decoder = JSONDecoder()
                    let books = try decoder.decode(BooksResponse.self, from: _data)
                    self.createMedBooks(books: books.docs)
                    self.saveData(dataManager: dataManager, books: self.medBooks)
                    completion(books,nil)
                }catch {
                    completion(nil,error.localizedDescription)
                }
            }
        }
    }
    

    private func createMedBooks(books : [Book]){
        
        self.medBooks = []
        
        for book in books {
            let imageUrl = "https://covers.openlibrary.org/b/id/\(book.cover_i)-M.jpg"
            self.medBooks.append(
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
    private func saveData(dataManager : HomeScreenDataManager,books : [MedBook]){
        
        dataManager.save(books: books, completionHandler: { result in
            switch result {
            case .success(_):
                print("books saved!!!")
            case .failure(_):
                print("books not saved!!!")
            }
        })
    }

}
