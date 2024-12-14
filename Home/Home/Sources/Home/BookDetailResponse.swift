//
//  BookDetailResponse.swift
//  Home
//
//  Created by Manikandan on 12/12/24.
//

struct BookDetailResponse : Codable{
    let description : DescriptionData?
    let created : PublishedDate?
}

struct DescriptionData : Codable{
    let value : String?
}

struct PublishedDate: Codable{
    let value : String?
}
