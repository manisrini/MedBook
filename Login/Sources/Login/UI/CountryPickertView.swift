//
//  SwiftUIView.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import SwiftUI

struct CountryPickerView: View {
    @State var selectedCountry = "India"
    let countries = [
        "Cameroon",
        "Australia",
        "India",
        "Nepal",
        "Caeroon",
        "Autralia",
        "Inia",
        "Npal"
    ]

    var body: some View {
        Picker("Select a Country", selection: $selectedCountry){
            ForEach(countries, id: \.self) { country in
                Text(country)
            }
        }
        .pickerStyle(.wheel)
        .frame(height: 140)
    }
}

#Preview {
    CountryPickerView()
}
