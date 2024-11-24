//
//  CountryData.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

struct CountryData: Codable,Hashable {
    let country: String
}

struct CountryResponse: Codable {
    let data: [String: CountryData]
}

struct DefaultCountry : Codable{
    let countryCode : String
}
