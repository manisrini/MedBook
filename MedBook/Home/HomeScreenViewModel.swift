//
//  HomeScreenViewModel.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

import NetworkManager
import Foundation

class HomeScreenViewModel{
    
    
    var medBooks : [Book] = []
    
    func fetchBooks(completion : @escaping(BooksResponse?,String?) -> Void){
        Task{
            let url = "https://openlibrary.org/search.json?title=game&limit=10"
            let (data, _) = await NetworkManager.shared.getData(urlStr: url)
                
            guard let _data = data else{ return }

            do{
                let decoder = JSONDecoder()
                let books = try decoder.decode(BooksResponse.self, from: _data)
                self.medBooks = books.docs
                completion(books,nil)
            }catch {
                completion(nil,error.localizedDescription)
            }
        }
    }
}
