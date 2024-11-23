//
//  BookDetailCellView.swift
//  MedBook
//
//  Created by Manikandan on 21/11/24.
//

import SwiftUI
import DesignSystem


struct BookDetailCellView: View {
    
    let book : MedBook
    
    var body: some View {
        
        VStack(alignment : .leading){
            HStack{
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .frame(height: 70)
                    .overlay {
                        HStack{
                            
                            if let imageUrl = book.imageUrl{
                                CustomImageView(url: imageUrl)
                                    .frame(width: 60,height: 60)
                                    .background(Color.gray)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                                    .padding(.horizontal,5)
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
                                
                                HStack{
                                    Text(book.author_name)
                                    
                                    HStack(spacing:1){
                                        Image(systemName: "star")
                                        Text("\(book.ratings_average.formatDecimal())")
                                    }
                                    
                                    HStack(spacing:1){
                                        Image(systemName: "star")
                                        Text("\(book.ratings_count)")
                                    }
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
            id: 1, title: "Hacking With Swift",
            ratings_average: 5.3,
            ratings_count: 4,
            author_name: "mani",
            imageUrl: nil,
            isBookMarked: true
        )
    )
}
