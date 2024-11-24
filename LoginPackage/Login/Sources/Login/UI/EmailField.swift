//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI

struct EmailField: View {
    
    @Binding var email : String
    
    var body: some View {
        TextField("Enter email", text: $email)
            .keyboardType(.emailAddress)
            .padding(8)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(Color.gray.opacity(0.3)),
                alignment: .bottom
            )
            .autocapitalization(.none)

    }
}

#Preview {
    EmailField(email: .constant(""))
}
