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
                            Text(book.title)
                            
                            HStack{
                                Text(book.author_name)
                                
                                HStack(spacing:1){
                                    Image(systemName: "star")
                                    Text("\(book.ratings_average)")
                                }
                                
                                HStack(spacing:1){
                                    Image(systemName: "star")
                                    Text("\(book.ratings_count)")
                                }
                            }
                        }
                    }
                }
            
            
            if book.isBookMarked{
                Button {
                    print("pressed")
                } label: {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(Color.green)
                        .frame(width:40, height: 40)
                        .overlay{
                            Image(systemName: "heart")
                        }
                        .padding(.trailing,10)
                }
            }
        }
        
    }
    
   
}


extension Double{
    public func formatDecimal(_ number: Double) -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        return formatter.string(from: NSNumber(value: number)) ?? "\(number)"
    }
}

#Preview {
    BookDetailCellView(
        book: .init(
            title: "Hacking With Swift",
            ratings_average: 5.3,
            ratings_count: 4,
            author_name: "mani",
            imageUrl: nil
        )
    )
}
