//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import SwiftUI

struct LoginInputView : View {
    
    @Binding var email : String
    @Binding var userPassword : String
    @Binding var isEmailValid : Bool
    @Binding var isPasswordValid : Bool
    @Binding var minCharacterSatisfied : Bool
    @Binding var upperCaseSatisfied : Bool
    @Binding var specialCharSatisfied : Bool
    @Binding var canLogin : Bool

    var body: some View {
        VStack(spacing : 20){
            
            HStack{
                EmailField(email: $email)
                    .onChange(of: email) {
                        validateInputs()
                    }
                
                if isEmailValid{
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .tint(.green)
                        .frame(width: 20,height: 20)
                        .padding(.trailing,10)
                    
                }
            }
            
            PasswordField(userPassword: $userPassword)
                .onChange(of: userPassword) {
                    validateInputs()
            }
        }
    }
    
    
    private func validateInputs() {
        isEmailValid = validateEmail()
        isPasswordValid = validatePassword()
        if isEmailValid && isPasswordValid{
            canLogin = true
        }else{
            canLogin = false
        }
        
    }
    
    private func validateEmail() -> Bool {
        let emailRegex = "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,}$"
        return email.range(of: emailRegex, options: [.regularExpression, .caseInsensitive]) != nil
    }
    
    private func validatePassword() -> Bool{
        minCharacterSatisfied = userPassword.count >= 8
        upperCaseSatisfied = userPassword.rangeOfCharacter(from: .uppercaseLetters) != nil
        specialCharSatisfied = userPassword.rangeOfCharacter(from: .punctuationCharacters.union(.symbols)) != nil
        return minCharacterSatisfied && upperCaseSatisfied && specialCharSatisfied
    }

}

#Preview {
//    LoginInputView()
}
