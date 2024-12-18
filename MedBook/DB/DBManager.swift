//
//  DBManager.swift
//  MedBook
//
//  Created by Manikandan on 22/11/24.
//

import Foundation
import CoreData

class DBManager{
    let dbName = "MedBook"
    static let shared = DBManager()
    
    private init(){}
    
    public lazy var persistentContainer : NSPersistentContainer = {
        let container = NSPersistentContainer(name: dbName)
        container.loadPersistentStores { storeDesc, error in
            if let _error = error as NSError?{
                print(_error.localizedDescription)
            }
        }
        return container
    }()
    
    func saveContext(managedObjectContext: NSManagedObjectContext, completionHandler: @escaping(Result<String,Error>) -> Void){
        do {
            try managedObjectContext.save()
            completionHandler(.success("Saved to DB Successfully"))
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
 /*   func retrieveData(entityName : String,predicate : NSPredicate?,completionHandler : @escaping(Result<[Any],Error>) -> Void){
        let managedContext = persistentContainer.viewContext
        let fetchReq = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if let _predicate = predicate{
            fetchReq.predicate = _predicate
        }
        
        do {
            let result = try managedContext.fetch(fetchReq)
            if let arrObj = res as? [Any]{
                completionHandler(.success(arrObj))
            }else{
                completionHandler(.success([]))
            }
        }catch{
            completionHandler(.failure(error))
        }
        
    }
    
    public func convertToJSONArray(moArray: [NSManagedObject]) -> Any {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
*/
}
