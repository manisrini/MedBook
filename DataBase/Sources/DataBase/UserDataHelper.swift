//
//  Untitled.swift
//  Login
//
//  Created by Manikandan on 24/11/24.
//
import Foundation
import CoreData
import CryptoKit

@MainActor
final public class UserDataHelper
{
    public static let entityName : String = "User"
    
    private init() {}
    
    public static func signupUser(
        dbManager: DatabaseManager = DatabaseManager.shared,
        userDetails: UserDetail,
        completionHandler: @escaping (Result<Bool, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", userDetails.email)

        do {
            let existingUsers = try managedContext.fetch(fetchRequest)
            if !existingUsers.isEmpty {
                completionHandler(.failure(NSError(domain: "Signup", code: 409, userInfo: [NSLocalizedDescriptionKey: "Email already registered."])))
                return
            }
            
            // Create new user
            if let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext),
               let newUser = NSManagedObject(entity: entity, insertInto: managedContext) as? User {
                newUser.id = userDetails.id
                newUser.email = userDetails.email
                newUser.password = hashPassword(userDetails.password)
                newUser.country = userDetails.country
                newUser.isLoggedIn = true
            }
            
            dbManager.save(managedObjectContext: managedContext) { result in
                switch result {
                case .success:
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

    private static func hashPassword(_ password: String) -> String {
        let passwordData = Data(password.utf8)
        let hashed = SHA256.hash(data: passwordData)
        return hashed.compactMap { String(format: "%02x", $0) }.joined()
    }
    
    public static func loginUser(
        dbManager: DatabaseManager = DatabaseManager.shared,
        email: String,
        password: String,
        completionHandler: @escaping (Result<Bool, Error>) -> Void
    ) {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            if let user = users.first, user.password == hashPassword(password) {
                user.isLoggedIn = true
                dbManager.save(managedObjectContext: managedContext) { result in
                    switch result {
                    case .success:
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                    }
                }
            } else {
                completionHandler(.failure(NSError(domain: "Login", code: 401, userInfo: [NSLocalizedDescriptionKey: "Invalid credentials."])))
            }
        } catch {
            completionHandler(.failure(error))
        }
    }
    
    
    public static func isUserLoggedIn(dbManager: DatabaseManager = DatabaseManager.shared) -> Bool {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == YES")
        
        do {
            let loggedInUsers = try managedContext.fetch(fetchRequest)
            return !loggedInUsers.isEmpty
        } catch {
            print("Error checking login status: \(error.localizedDescription)")
            return false
        }
    }
    
    public static func logoutUser(dbManager: DatabaseManager = DatabaseManager.shared, completionHandler: @escaping (Result<Bool, Error>) -> Void) {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == YES")
        
        do {
            let loggedInUsers = try managedContext.fetch(fetchRequest)
            for user in loggedInUsers {
                user.isLoggedIn = false
            }
            
            dbManager.save(managedObjectContext: managedContext) { result in
                switch result {
                case .success:
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        } catch {
            completionHandler(.failure(error))
        }
    }

    
    public static func getLoggedInUserId(dbManager: DatabaseManager) -> UUID? {
        let managedContext = dbManager.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "isLoggedIn == YES")
        
        do {
            let users = try managedContext.fetch(fetchRequest)
            return users.first?.id
        } catch {
            print("Error fetching logged-in user: \(error.localizedDescription)")
            return nil
        }
    }


}
