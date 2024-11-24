//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import SwiftUI
import Utilities
import DesignSystem

struct LandingView: View {
    
    var didTapLogin : (()->())?
    var didTapSignup : (()->())?
    
    var body: some View {
        
        ZStack{
            AppThemeView()

            GeometryReader{_ in
                Text("MedBook")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(20)
                
                
                
                VStack(spacing : 20){
                    Image("book",bundle: .module)
                        .resizable()
                        .frame(height: 300)
                        .padding(20)
                    
                    
                    Spacer()
                    
                    HStack(spacing: 25){
                        Button {
                            self.didTapLogin?()
                        } label: {
                            MBChipView(text: "Login")
                        }
                        
                        Button {
                            self.didTapSignup?()
                        } label: {
                            MBChipView(text: "Signup")
                        }
                    }
                    
                }
                .padding(.vertical,50)
            }
        }

    }
}

struct MBChipView : View{
    
    var text : String
    var padding : CGFloat = 25
    var height : CGFloat = 30
    
    var body: some View {
        Text(text)
            .padding(.horizontal, padding)
            .frame(height: height)
            .padding(.vertical, 6)
            .foregroundColor(.black)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.black, lineWidth: 1)
            )
    }
}

#Preview {
//    MBChipView(text: "Test label")
    LandingView()
}
