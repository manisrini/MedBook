//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 23/11/24.
//

import SwiftUI
import Utilities
import DesignSystem

struct SignUpView: View {
    
    var didTapSignUp: (()->())?
    @State var email : String = ""
    @State var userPassword : String = ""
    @State var isEmailValid : Bool = false
    @State var isPasswordValid : Bool = false
    @State var minCharacterSatisfied : Bool = false
    @State var upperCaseSatisfied : Bool = false
    @State var specialCharSatisfied : Bool = false
    @State var canSignUp : Bool = false
    @ObservedObject var viewModel : SignUpViewModel = SignUpViewModel()
    @State var errorMsg : String = ""
//    @State var selectedCountry : String = ""
    
    var body: some View {
        
        ZStack{
            AppThemeView()
            
            GeometryReader{ _ in
                
                VStack(alignment : .leading){
                    
                    LoginHeadingView(headline: "SignUp to continue")
                    
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
                    
                    
                    if !errorMsg.isEmptyOrWhitespace(){
                        Text(errorMsg)
                            .foregroundStyle(.red)
                    }

                    VStack(alignment: .leading, spacing: 25) {
                        PasswordRequirementRow(requirement: "At least 8 characters", isSatisfied: $minCharacterSatisfied)
                        PasswordRequirementRow(requirement: "Must contain an uppercase letter", isSatisfied: $upperCaseSatisfied)
                        PasswordRequirementRow(requirement: "Contains a special character", isSatisfied: $specialCharSatisfied)
                    }
                    .padding(.top, 20)
                    
                    if viewModel.isLoading{
                        HStack{
                            ProgressView("Loading")
                                .frame(maxWidth: .infinity)
                        }
                        .frame(alignment: .center)
                        .padding(.top,50)
                    }else{
                        CountryPickerView(selectedCountry: $viewModel.selectedCountry, countries: viewModel.countries.map({ country in
                            country.country
                        }))
                            .padding(.top,50)
                    }
                    
                    
                    Spacer()
                    
                    HStack {
                        Button {
                            MBLoader.show()
                            
                            viewModel.saveUserToDB(
                                email: email,
                                password: userPassword,
                                country: viewModel.selectedCountry) { success, error in
                                    
                                    MBLoader.hide()

                                    if success{
                                        self.didTapSignUp?()
                                    }else{
                                        self.errorMsg = error
                                    }
                                }
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
        .onAppear{
            Task{
                await viewModel.fetchData()
            }
        }

    }
}

struct LoginHeadingView : View {
    
    var headline : String
    
    var body: some View {
        //Heading View
        VStack(alignment : .leading){
            Text("Welcome")
                .font(.largeTitle)
            Text(headline)
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
                .foregroundColor(isSatisfied ? .green : .red)

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
