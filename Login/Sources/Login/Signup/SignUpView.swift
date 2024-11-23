//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import SwiftUI

struct SignUpView: View {
    
    @State var email : String = ""
    @State var userPassword : String = ""
    @State var isEmailValid : Bool = false
    @State var isPasswordValid : Bool = false
    @State var minCharacterSatisfied : Bool = false
    @State var upperCaseSatisfied : Bool = false
    @State var specialCharSatisfied : Bool = false
    @State var canSignUp : Bool = false
    var didTapLogin : (()->())?
    
    var body: some View {
                
        ZStack{
            
            Color.gray.opacity(0.5)
            
            GeometryReader{ _ in
                
                VStack(alignment : .leading){
                    
                    LoginHeadingView()
                    
                    LoginInputView(
                        email: $email,
                        userPassword: $userPassword,
                        isEmailValid: $isEmailValid,
                        isPasswordValid: $isPasswordValid,
                        minCharacterSatisfied:$minCharacterSatisfied
                        ,upperCaseSatisfied: $upperCaseSatisfied,
                        specialCharSatisfied: $specialCharSatisfied,
                        canLogin: $canSignUp
                    )
                        .padding(.top,25)

                    VStack(alignment: .leading, spacing: 25) {
                        PasswordRequirementRow(requirement: "At least 8 characters", isSatisfied: $minCharacterSatisfied)
                        PasswordRequirementRow(requirement: "Must contain an uppercase letter", isSatisfied: $upperCaseSatisfied)
                        PasswordRequirementRow(requirement: "Contains a special character", isSatisfied: $specialCharSatisfied)
                    }
                    .padding(.top, 20)
                    
                    CountryPickerView()
                        .padding(.top,50)
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            self.didTapLogin?()
                        } label: {
                            MBChipView(text: "Sign Up")
                                .frame(maxWidth: .infinity)
                        }
                        .opacity(canSignUp ? 1 : 0.3)
                        .disabled(!canSignUp)
                    }
                    .frame(alignment: .center)
                }
                .padding(.leading,10)
                
            }
        }

    }
}

struct LoginHeadingView : View {
    var body: some View {
        //Heading View
        VStack(alignment : .leading){
            Text("Welcome")
                .font(.largeTitle)
            Text("Sign up to continue")
                .font(.headline)
        }
        

    }
}


struct PasswordRequirementRow: View {
    let requirement: String
    @Binding var isSatisfied: Bool
    
    var body: some View {
        HStack {
            Image(systemName: isSatisfied ? "checkmark.square" : "square")
                .foregroundColor(.gray)
            
            Text(requirement)
                .font(.subheadline)
                .foregroundColor(.black)
        }
    }
}

#Preview {
//    PasswordRequirementRow(requirement: "Max characters")
    SignUpView()
}
