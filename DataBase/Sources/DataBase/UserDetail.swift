//
//  UserDetail.swift
//  DataBase
//
//  Created by Manikandan on 24/11/24.
//

import Foundation


public struct UserDetail {
    let id : UUID = UUID()
    let email : String
    let password : String
    let country : String
    
    public init(email: String, password: String, country: String) {
        self.email = email
        self.password = password
        self.country = country
    }
}
