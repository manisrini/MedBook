//
//  BookDetailCellView.swift
//  MedBook
//
//  Created by Manikandan on 21/11/24.
//

import SwiftUI
import DesignSystem
import DataBase

struct BookDetailCellView: View {
    
    let book : MedBook
    
    var body: some View {
        
        VStack(alignment : .leading){
            HStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white)
                    .frame(height: 70)
                    .overlay {
                        HStack{
                            
                            if let imageUrl = book.imageUrl{
                                CustomImageView(url: imageUrl)
                                    .frame(width: 60,height: 60)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.horizontal,5)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 5)
                                            .stroke(Color.black.opacity(0.8), lineWidth: 1)
                                    )
                                    .padding(.leading,5)
                            }
                            
                            VStack(alignment:.leading){
                                
                                HStack{
                                    Text(book.title)
                                    Spacer()
                                    
                                    if book.isBookMarked{
                                        Image(systemName: "bookmark.fill")
                                            .resizable()
                                            .frame(width:15, height: 20)
                                            
                                    }
                                }
                                
                                HStack(spacing: 10){
                                    Text(book.author_name)
                                        .fixedSize(horizontal: false, vertical: true)
                                        .font(.system(size: 14))
                                        .lineLimit(2)
                                        .frame(width: 150,alignment: .leading)
                                    
                                    
                                    
                                    HStack(spacing:1){
                                        Image(systemName: "star.fill")
                                            .foregroundStyle(Color.yellow)
                                        Text("\(book.ratings_average.formatDecimal())")
                                    }
                                    .frame(width: 50)
                                    
                                    HStack(spacing:1){
                                        Image(systemName: "document.fill")
                                            .foregroundStyle(Color.yellow)
                                        Text("\(book.ratings_count)")
                                    }
                                    .frame(width: 60)
                                }
                            }
                            
                            Spacer()
                        }
                    }
            }
            
        }
        
    }
}

#Preview {
    BookDetailCellView(
        book: .init(
            title: "Hacking With Swift",
            ratings_average: 5.3,
            ratings_count: 4,
            author_name: "manikandan srinivasan test",
            imageUrl: nil,
            cover_edition_key: "",
            isBookMarked: true
        )
    )
}
