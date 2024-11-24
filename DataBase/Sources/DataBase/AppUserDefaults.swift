//
//  MBUserDefaults.swift
//  DataBase
//
//  Created by Manikandan on 24/11/24.
//

import Foundation

public struct UserDefaultKeys{
    static let CountryCode = "CountryCode"
}

@MainActor
public class AppUserDefaults {
    
    static let appUserDefault = UserDefaults.standard
    
    public class func setCountryCode(id : String){
        appUserDefault.setValue(id, forKey: UserDefaultKeys.CountryCode)
        appUserDefault.synchronize()
    }
    
    public class func getCountryCode() -> String?{
        if let countryCode = appUserDefault.object(forKey: UserDefaultKeys.CountryCode) as? String{
            return countryCode
        }
        return nil
    }
    
}
