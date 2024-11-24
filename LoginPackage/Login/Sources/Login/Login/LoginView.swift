//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI
import DesignSystem
import Utilities
import DataBase

struct LoginView: View {
    
    var didTapLogin : (()->())?
    @State var email : String = ""
    @State var userPassword : String = ""
    @State var isValidCredentials : Bool = true
    @State var errorString : String = "Please Enter Valid Credentials"
    
    var body: some View {
        ZStack{
            
            AppThemeView()
            
            GeometryReader{ _ in
                
                VStack(alignment : .leading){
                    
                    LoginHeadingView(headline: "Login to continue")
                    
                    EmailField(email: $email)
                        .padding(.top,25)
                    
                    PasswordField(userPassword: $userPassword)
                        .padding(.top,25)
                    
                    
                    if !isValidCredentials{
                        Text(errorString)
                            .foregroundStyle(.red)
                            .padding(.top,20)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            MBLoader.show()
                            isValid{ success in
                                MBLoader.hide()
                                if success{
                                    self.isValidCredentials = true
                                    self.didTapLogin?()
                                }else{
                                    self.isValidCredentials = false
                                }
                            }
                        } label: {
                            MBChipView(text: "Login")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(disable())
                    .opacity(disable() ? 0.3 : 1)
                    .frame(alignment: .center)
                }
                .padding(.leading,10)
                
            }
        }
        
    }
    
    private func disable() -> Bool{
        if email.isEmptyOrWhitespace() || userPassword.isEmptyOrWhitespace(){
            return true
        }
        return false
    }
    
    private func isValid(completion : @escaping(Bool) -> Void){
        UserDataHelper.loginUser(email: email, password: userPassword) { result in
            switch result {
            case .success(let isValid):
                completion(isValid)
            case .failure(let error):
                self.errorString = error.localizedDescription
                completion(false)
            }
        }
    }
    
}

    


#Preview {
    LoginView {
        
    }
}
