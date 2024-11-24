// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import CoreData

public enum DBError : Error {
    case Unknown
    case NoRecord
}

public enum DBName : String
{
    case MedBook = "MedBook"
}


@MainActor

public class DatabaseManager {
    
    var dbName : String = ""
    public var persistentContainer : NSPersistentContainer!
    public static let shared = DatabaseManager(dbName: .MedBook)

    private init(dbName: DBName) {
       self.dbName = dbName.rawValue
       self.initialisePersistentContainer()
    }

    func initialisePersistentContainer() {
        let bundle = Bundle.module
        if let modelURL = bundle.url(forResource: dbName, withExtension: ".momd"){
            if let model = NSManagedObjectModel(contentsOf: modelURL){
                self.persistentContainer = NSPersistentContainer(name: self.dbName, managedObjectModel: model)
                self.initialize()
            }
        }else{
            print("Could not load model")
        }
    }
    
    private func initialize() {
        self.persistentContainer.loadPersistentStores { description, error in
            if let err = error {
                fatalError("Failed to load CoreData: \(err)")
            }
            print("Core data loaded: \(description)")
        }
    }
            
    public func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    public func save(managedObjectContext: NSManagedObjectContext, completionHandler: @escaping(Result<String,Error>) -> Void)
    {
        do {
            try managedObjectContext.save()
            completionHandler(.success("Saved to DB Successfully"))
        } catch let error {
            completionHandler(.failure(error))
        }
    }
    
   
}
