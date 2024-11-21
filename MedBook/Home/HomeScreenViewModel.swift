//
//  HomeScreenViewModel.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

import NetworkManager
import Foundation


struct MedBook{
    let title : String
    let ratings_average : Double
    let ratings_count : Int
    let author_name : String
    let imageUrl : String?
    let isBookMarked : Bool = false
}

class HomeScreenViewModel{
    
    var medBooks : [MedBook] = []
    
    func fetchBooks(completion : @escaping(BooksResponse?,String?) -> Void){
        Task{
            let url = "https://openlibrary.org/search.json?title=game&limit=10"
            let (data, _) = await NetworkManager.shared.getData(urlStr: url)
                
            guard let _data = data else{ return }

            do{
                let decoder = JSONDecoder()
                let books = try decoder.decode(BooksResponse.self, from: _data)
                self.createMedBooks(books: books.docs)
                completion(books,nil)
            }catch {
                completion(nil,error.localizedDescription)
            }
        }
    }
    

    private func createMedBooks(books : [Book]){
        
        self.medBooks = []
        
        for book in books {
            let imageUrl = "https://covers.openlibrary.org/b/id/\(book.cover_i)-M.jpg"
            self.medBooks.append(
                .init(
                    title: book.title,
                    ratings_average: book.ratings_average,
                    ratings_count: book.ratings_count,
                    author_name: book.author_name.first ?? "",
                    imageUrl: imageUrl
                )
            )
        }
    }

}
