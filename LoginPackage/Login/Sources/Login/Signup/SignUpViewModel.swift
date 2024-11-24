//
//  SignUpViewModel.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//

import Foundation
import NetworkManager
import CryptoKit
import DataBase

@MainActor
class SignUpViewModel : ObservableObject{
    
    @Published var countries : [CountryData] = []
    @Published var isLoading : Bool = false
    @Published var selectedCountry : String = ""
    
    func fetchData() async{
        self.isLoading = true
        
        let countryCode = await self.fetchDefaultCountry()
        let countries = await self.fetchCountries()
        self.isLoading = false
        self.countries = self.createCountriesModel(for: countries,defaultCountryCode: countryCode)
    }
    
    
    
    func fetchCountries() async -> ([String:CountryData]) {
        
        let countriesFromDB = self.fetchCountriesFromDB()
        
        if countriesFromDB.count > 0{
            var tempCountries : [String : CountryData] = [:]
            for country in countriesFromDB {
                tempCountries.updateValue(
                    CountryData(country: country.name ?? ""),
                    forKey: country.code ?? ""
                )
            }
            return tempCountries
            
        }else{
            let url = "https://api.first.org/data/v1/countries"
            
            let (data,_) = await NetworkManager.shared.getData(urlStr: url)
            guard let data = data else{ return [:] }

            do{
                let decoder = JSONDecoder()
                let countries = try decoder.decode(CountryResponse.self, from: data)
                self.addCountriesToDB(countries: countries.data)
                return countries.data
            }catch {
                print(error)
                return [:]
            }
        }
    }
    
    func fetchDefaultCountry() async -> String{
        
        if let countryCode = AppUserDefaults.getCountryCode(){
            return countryCode
        }else{
            let url = "http://ip-api.com/json"
            
            let (data,error) = await NetworkManager.shared.getData(urlStr: url)
            
            guard let data = data else{ return error ?? "" }

            do{
                let decoder = JSONDecoder()
                let country = try decoder.decode(DefaultCountry.self, from: data)
                AppUserDefaults.setCountryCode(id: country.countryCode)
                return country.countryCode
            }catch {
                print(error)
                return ""
            }
        }
    }
    
    func createCountriesModel(for data : [String:CountryData],defaultCountryCode : String) -> [CountryData]{
        var countries : [CountryData] = []
        for (key,value) in data{
            if defaultCountryCode == key{ //Set default Country
                self.selectedCountry = value.country
            }
            countries.append(value)
        }
        return countries
    }
    
    
    func saveUserToDB(email : String,password : String,country : String,completion : @escaping(Bool,String) -> Void){
        let user = UserDetail(email: email, password: password, country: country)
        
        UserDataHelper.signupUser(userDetails: user) { result in
            switch result {
            case .success(let success):
                completion(success,"")
            case .failure(let error):
                completion(false,error.localizedDescription)
            }
        }
    }
    
    func addCountriesToDB(countries : [String:CountryData]){
        
        var formattedCountries : [String:String] = [:]
        
        for (key,value) in countries{
            formattedCountries.updateValue(value.country, forKey: key)
        }
        
        CountryDataHelper.insertCountries(dbManager: DatabaseManager.shared, countries: formattedCountries)
    }
    
    func fetchCountriesFromDB() -> [Countries]{
        let countries = CountryDataHelper.fetchCountries(dbManager:  DatabaseManager.shared)
        return countries
    }
    
    

}


