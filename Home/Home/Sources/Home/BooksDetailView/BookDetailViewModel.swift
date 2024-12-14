//
//  BookDetailViewModel.swift
//  Home
//
//  Created by Manikandan on 12/12/24.
//
import DataBase
import NetworkManager
import Foundation
import UIKit

public let defaultStr = "---"

@MainActor
class BookDetailViewModel : ObservableObject{
    
    @Published var book : BookDetail?
    @Published var isLoading : Bool = true
    var medBook : MedBook
    
    init(medBook: MedBook) {
        self.medBook = medBook
    }
    
    func fetchBookDetails(for book : MedBook) async{
        
        let key = book.cover_edition_key
        self.isLoading = true
        Task {
            let url = "https://openlibrary.org/works/\(key).json"
            let (data, _) = await NetworkManager.shared.getData(urlStr: url)
            
            guard let _data = data else{ return }
            
            do{
                let decoder = JSONDecoder()
                let bookDetailResponse = try decoder.decode(BookDetailResponse.self, from: _data)
                self.book = self.createBookDetail(response: bookDetailResponse)
                self.isLoading = false
            }catch {
                print("Invalid record")
                self.book = self.createNoResponseBookDetail()
                self.isLoading = false
            }
        }
    }
    
    func createBookDetail(response : BookDetailResponse) -> BookDetail{
        
        let date = response.created?.value?.components(separatedBy: "T")
        
        return BookDetail(
            title: self.medBook.title,
            imageUrl: self.medBook.imageUrl,
            date: date?.first ?? "",
            author: self.medBook.author_name,
            description: response.description?.value ?? "No Description Found"
        )
    }
    
    func createNoResponseBookDetail() -> BookDetail{
                
        return BookDetail(
            title: self.medBook.title,
            imageUrl: self.medBook.imageUrl,
            date: defaultStr,
            author: self.medBook.author_name,
            description: defaultStr
        )
    }
    
    func saveBookMarkStatus(completion : @escaping() -> Void){
        self.medBook.isBookMarked.toggle()
        
        let dbManager = DatabaseManager.shared
        if let loggedInUserId = UserDataHelper.getLoggedInUserId(dbManager: dbManager){
            
            BookMarkDataHelper.addBookmark(dbManager: dbManager, userId: loggedInUserId, bookmarkDetails: medBook) { result in
                completion()
            }
        }
        
    }
    
    func removeBookMarkFromDB(for id : UUID,completion : @escaping() -> Void){
        let dbManager = DatabaseManager.shared
        
        if let loggedInUserId = UserDataHelper.getLoggedInUserId(dbManager: dbManager){
            BookMarkDataHelper.deleteBookmark(dbManager: dbManager, userId: loggedInUserId, bookmarkId: id) { result in
                completion()
            }
        }
    }

}
