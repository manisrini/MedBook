//
//  Untitled.swift
//  DataBase
//
//  Created by Manikandan on 24/11/24.
//

import CoreData

// MARK: - Insert Country Data

@MainActor
public class CountryDataHelper {
    
    
    public static func insertCountries(dbManager: DatabaseManager,countries: [String : String]) {
        
        let managedContext = dbManager.persistentContainer.viewContext

        for (code, name) in countries {
            if let entity = NSEntityDescription.entity(forEntityName: "Countries", in: managedContext),
               let newCountry = NSManagedObject(entity: entity, insertInto: managedContext) as? Countries {
                newCountry.code = code
                newCountry.name = name
            }
        }
        
        dbManager.save(managedObjectContext: managedContext) { result in
            
        }
    }

    // MARK: - Fetch Country Data
    public static func fetchCountries(
        dbManager: DatabaseManager) -> [Countries] {
        let managedContext = dbManager.persistentContainer.viewContext

        let fetchRequest: NSFetchRequest<Countries> = Countries.fetchRequest()

        do {
            let countries = try managedContext.fetch(fetchRequest)
            return countries
        } catch {
            return []
        }
    }


}
