//
//  BookMarkDataHelper.swift
//  DataBase
//
//  Created by Manikandan on 24/11/24.
//

import CoreData

public struct MedBook{
    public let id : UUID = UUID()
    public let title : String
    public let ratings_average : Double
    public let ratings_count : Int
    public let author_name : String
    public let imageUrl : String?
    public var isBookMarked : Bool
    
    public init(title: String, ratings_average: Double, ratings_count: Int, author_name: String, imageUrl: String?, isBookMarked: Bool = false) {
        self.title = title
        self.ratings_average = ratings_average
        self.ratings_count = ratings_count
        self.author_name = author_name
        self.imageUrl = imageUrl
        self.isBookMarked = isBookMarked
    }
}


@MainActor

final public class BookMarkDataHelper{
    
    public static func addBookmark(
        dbManager: DatabaseManager,
        userId: UUID,
        bookmarkDetails: MedBook,
        completionHandler: @escaping (Result<Bool, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            if let user = users.first {

                if let entity = NSEntityDescription.entity(forEntityName: "BookMarks", in: managedContext),
                   let newBookmark = NSManagedObject(entity: entity, insertInto: managedContext) as? BookMarks {
                    newBookmark.id = bookmarkDetails.id
                    newBookmark.author_name = bookmarkDetails.author_name
                    newBookmark.title = bookmarkDetails.title
                    newBookmark.ratings_avg = bookmarkDetails.ratings_average
                    newBookmark.ratings_count = Int64(bookmarkDetails.ratings_count)
                    newBookmark.imageUrl = bookmarkDetails.imageUrl
                    
                    // Add the bookmark to the user
                    user.addToBookMarks(newBookmark)
                }
                
                dbManager.save(managedObjectContext: managedContext) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            } else {
                completionHandler(.failure(NSError(domain: "Bookmark", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found."])))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

    
    public static func fetchBookmarks(
        dbManager: DatabaseManager,
        userId: UUID,
        completionHandler: @escaping (Result<[BookMarks], Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            if let user = users.first, let bookmarks = user.bookMarks?.allObjects as? [BookMarks] {
                completionHandler(.success(bookmarks))
            } else {
                completionHandler(.failure(NSError(domain: "BookMark", code: 404, userInfo: [NSLocalizedDescriptionKey: "No bookmarks found for the user."])))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

    
    public static func deleteBookmark(
        dbManager: DatabaseManager,
        userId: UUID,
        bookmarkId: UUID,
        completionHandler: @escaping (Result<Bool, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        
        let userFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        userFetchRequest.predicate = NSPredicate(format: "id == %@", userId as CVarArg)
        
        do {
            let users = try managedContext.fetch(userFetchRequest)
            if let user = users.first, let bookmarks = user.bookMarks?.allObjects as? [BookMarks] {
                // Find the bookmark to delete
                if let bookmarkToDelete = bookmarks.first(where: { $0.id == bookmarkId}) {
                    managedContext.delete(bookmarkToDelete)
                    
                    dbManager.save(managedObjectContext: managedContext) { result in
                        switch result {
                        case .success:
                            completionHandler(.success(true))
                        case .failure(let error):
                            completionHandler(.failure(error))
                        }
                    }
                } else {
                    completionHandler(.failure(NSError(domain: "Bookmark", code: 404, userInfo: [NSLocalizedDescriptionKey: "Bookmark not found."])))
                }
            } else {
                completionHandler(.failure(NSError(domain: "Bookmark", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found."])))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

}
