//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI

struct LoginView: View {
    
    @State var email : String = ""
    @State var userPassword : String = ""
    var didTapSignUp : (()->())?

    var body: some View {
        ZStack{
            
            Color.gray.opacity(0.5)
            
            GeometryReader{ _ in
                
                VStack(alignment : .leading){
                    
                    LoginHeadingView()
                    
                    EmailField(email: $email)
                        .padding(.top,25)

                    PasswordField(userPassword: $userPassword)
                        .padding(.top,25)

                    Spacer()
                    
                    HStack {
                        Button {
                            self.didTapSignUp?()
                        } label: {
                            MBChipView(text: "Login")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .frame(alignment: .center)
                }
                .padding(.leading,10)
                
            }
        }

    }}

#Preview {
    LoginView {
        
    }
}
