//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI

struct CountryPickerView: View {
    @Binding var selectedCountry : String
    let countries : [String]

    var body: some View {
        Picker("Select a Country", selection: $selectedCountry){
            ForEach(countries, id: \.self) { country in
                Text(country)
                    .tag(country)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 140)
    }
}

#Preview {
    CountryPickerView(selectedCountry: .constant("India"), countries: [])
}
