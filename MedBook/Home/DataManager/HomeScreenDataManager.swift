//
//  HomeScreenDataManager.swift
//  MedBook
//
//  Created by Manikandan on 22/11/24.
//

import CoreData


enum Entity : String{
    case MedBook = "MedBookData"
}

class HomeScreenDataManager
{
    let dbManager : DBManager = DBManager.shared
    
    public func saveBookMark(book : MedBook,completionHandler: @escaping(Result<Bool, Error>) -> Void){
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.MedBook.rawValue, in: managedContext){
            
            if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? MedBookData{
                dbObj.id = Int64(book.id)
                dbObj.title = book.title
                dbObj.author_name = book.author_name
                dbObj.ratings_avg = Float(book.ratings_average)
                dbObj.ratings_count = Int64(book.ratings_count)
                dbObj.imageUrl = book.imageUrl
            }
            
            dbManager.saveContext(managedObjectContext: managedContext) { result in
                switch result {
                case .success(_):
                    completionHandler(.success(true))
                default:
                    completionHandler(.success(false))
                }
            }
        }
    }
    
    func hasDataInDB() -> Bool {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Entity.MedBook.rawValue)
        let managedContext = dbManager.persistentContainer.viewContext
        
        do {
            let count = try managedContext.count(for: fetchRequest)
            return count > 0
        } catch {
            return false
        }
    }
    
    public func fetchBookMarksFromLocalDB() -> [MedBook] {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<MedBookData>(entityName: Entity.MedBook.rawValue)
                
        do {
            let fetchedResults = try managedContext.fetch(fetchRequest)

            
            let books: [MedBook] = fetchedResults.map { dbObj in
                return MedBook(
                    id: Int(dbObj.id),
                    title: dbObj.title ?? "",
                    ratings_average: Double(dbObj.ratings_avg),
                    ratings_count: Int(dbObj.ratings_count),
                    author_name: dbObj.author_name ?? "",
                    imageUrl: dbObj.imageUrl,
                    isBookMarked: dbObj.isBookMarked
                )
            }
            
            return books
        } catch {
            return []
        }
    }

    func deleteBookmark(byId id: Int, completion: (Error?) -> Void) {
        let fetchRequest: NSFetchRequest<MedBookData> = MedBookData.fetchRequest()
        fetchRequest.predicate = DBQueries.filterBy(bookId: id)
        let context = dbManager.persistentContainer.viewContext

            do {
                let bookmarks = try context.fetch(fetchRequest)
                if let bookmarkToDelete = bookmarks.first {
                    context.delete(bookmarkToDelete)
                    try context.save()
                    completion(nil)
                } else {
                    completion(nil)
                }
            } catch {
                completion(error)
            }
        }
}
