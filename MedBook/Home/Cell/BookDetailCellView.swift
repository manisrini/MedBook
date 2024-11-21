//
//  BookDetailCellView.swift
//  MedBook
//
//  Created by Manikandan on 21/11/24.
//

import SwiftUI

struct BookDetailCellView: View {
    var body: some View {
        
        HStack{
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray)
                .frame(height: 70)
                .overlay {
                    HStack{
                        Image(systemName: "alarm")
                            .resizable()
                            .frame(width: 60,height: 60)
                            .background(Color.gray)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                        
                        VStack(alignment:.leading){
                            Text("Game of Thrones")
                            
                            HStack{
                                Text("Manikandan")
                                
                                HStack(spacing:1){
                                    Image(systemName: "star")
                                    Text("4.5")
                                }
                                
                                HStack(spacing:1){
                                    Image(systemName: "star")
                                    Text("45")
                                }
                            }
                        }
                    }
                }
            
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


#Preview {
    BookDetailCellView()
}
