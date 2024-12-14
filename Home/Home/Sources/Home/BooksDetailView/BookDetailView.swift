//
//  SwiftUIView.swift
//  Home
//
//  Created by Manikandan on 12/12/24.
//

import SwiftUI
import DesignSystem
import DataBase

struct BookDetail{
    let title : String
    let imageUrl : String?
    let date: String
    let author : String
    let description : String
}

struct BookDetailView: View {
    
    @ObservedObject var viewModel : BookDetailViewModel
    
    init(viewModel: BookDetailViewModel) {
        self.viewModel = viewModel
    }
        
    var body: some View {
        
        GeometryReader{ reader in
            
            if viewModel.isLoading{
                VStack{
                    Spacer()
                    
                    ProgressView {
                        Text("Loading...")
                    }
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity,alignment: .center)
            }else{
                
                ScrollView{
                    VStack{
                        if let imageUrl = viewModel.book?.imageUrl{
                            CustomImageView(url: imageUrl)
                                .frame(width: UIScreen.main.bounds.size.width * 0.8,height: 300)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.black.opacity(0.8), lineWidth: 1)
                                )
                                .padding()
                        }
                        
                        
                        VStack(alignment: .leading,spacing: 10){
                            HStack(alignment: .top){
                                Text(viewModel.book?.title ?? defaultStr)
                                    .fontWeight(.bold)
                                    .frame(width: 200,alignment: .leading)
                                
                                
                                Spacer()
                                
                                Text(viewModel.book?.date ?? defaultStr)
                                    .foregroundStyle(.gray)
                            }
                            .padding(.top,5)
                            .padding(.horizontal,15)

                            HStack{
                                Text(viewModel.book?.author ?? defaultStr)
                                .fontWeight(.semibold)
                            }
                            .padding(.top,5)
                            .padding(.horizontal,15)
                            
                            HStack{
                                Text(viewModel.book?.description ?? "No Description found")
                                .foregroundStyle(.gray)
                            }
                            .padding(.top,5)
                            .padding(.horizontal,15)

                        }
                    }
                }
            }

        }
        .onAppear{
            Task{
                await viewModel.fetchBookDetails(for: viewModel.medBook)
            }
        }

    }
}

//#Preview {
//    BookDetailView(
//        bookData: MEd(
//            title: "Mani",
//            imageUrl: "",
//            date: "12/12/12",
//            author: "Manikandan",
//            description: "Hello World"
//        )
//    )
//}

