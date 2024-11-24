//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI

struct PasswordField: View {
    @Binding var userPassword : String
    
    var body: some View {
        SecureField("Enter password", text: $userPassword)
            .padding(8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3)),
                alignment: .bottom
            )
    }
}

#Preview {
    PasswordField(userPassword: .constant(""))
}
