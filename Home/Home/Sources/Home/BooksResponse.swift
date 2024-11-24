//
//  BooksResponse.swift
//  MedBook
//
//  Created by Manikandan on 20/11/24.
//

struct BooksResponse : Codable{
    let docs : [Book]
}

struct Book : Codable{
    let title : String
    let ratings_average : Double?
    let ratings_count : Int?
    let author_name : [String]?
    let cover_i : Int?
}
