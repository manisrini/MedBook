//
//  Untitled.swift
//  Home
//
//  Created by Manikandan on 24/11/24.
//

import Foundation
import CoreData
import DataBase

@MainActor
public class HomeScreenDataHelper
{
    public static let entityName : String = "User"
    
    public static func saveUser(dbManager : DatabaseManager,userDetails : String,completionHandler: @escaping(Result<Bool, Error>) -> Void)
    {
        let managedContext = dbManager.persistentContainer.viewContext
        if let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)
        {
            if let newData = NSManagedObject(entity: entity, insertInto: managedContext) as? User
            {
//                newData.id = userDetails.id
//                newData.country = userDetails.country
//                newData.email = userDetails.email
//                newData.password = userDetails.password
            }
            
            dbManager.save(managedObjectContext: managedContext) { result in
                switch result
                {
                case .success(_):
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }
    }
}
