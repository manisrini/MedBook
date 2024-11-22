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
    let dbManager : DBManager = DBManager()
    
    public func save(books : [MedBook],completionHandler: @escaping(Result<Bool, Error>) -> Void){
        let managedContext = dbManager.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: Entity.MedBook.rawValue, in: managedContext){
            
            for book in books {
                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? MedBookData{
                    dbObj.id = Int64(book.id)
                    dbObj.title = book.title
                    dbObj.author_name = book.author_name
                    dbObj.ratings_avg = Float(book.ratings_average)
                    dbObj.ratings_count = Int64(book.ratings_count)
                    dbObj.imageUrl = book.imageUrl
                    dbObj.isBookMarked = book.isBookMarked
                }
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

    
//    public func saveOffers(cardOffers : [CardOffer],completionHandler: @escaping(Result<Bool, Error>) -> Void){
//        let managedContext = dbManager.persistentContainer.viewContext
//        
//        if let entity = NSEntityDescription.entity(forEntityName: Entity.CardOffer.rawValue, in: managedContext){
//            
//            for offer in cardOffers {
//                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? CardOfferData{
//                    dbObj.id = offer.id
//                    dbObj.card_name = offer.card_name
//                    dbObj.image_url = offer.image_url
//                    dbObj.max_discount = offer.max_discount
//                    dbObj.offer_desc = offer.offer_desc
//                    dbObj.percentage = offer.percentage ?? 0.0
//                }
//            }
//            
//            dbManager.saveContext(managedObjectContext: managedContext) { result in
//                switch result {
//                case .success(_):
//                    completionHandler(.success(true))
//                default:
//                    completionHandler(.success(false))
//                }
//            }
//        }
//    }
    
//    public func saveProducts(products : [Product],completionHandler: @escaping(Result<Bool, Error>) -> Void){
//        let managedContext = dbManager.persistentContainer.viewContext
//        
//        if let entity = NSEntityDescription.entity(forEntityName: Entity.Product.rawValue, in: managedContext){
//            
//            for product in products {
//                if let dbObj = NSManagedObject(entity: entity, insertInto: managedContext) as? ProductData{
//                    dbObj.id = product.id
//                    dbObj.desc = product.description
//                    dbObj.image_url = product.image_url
//                    dbObj.name = product.name
//                    dbObj.isFavourite = false
//                    dbObj.price = Int64(product.price ?? 0)
//                    dbObj.rating = product.rating ?? 0
//                    dbObj.review_count = Int32(product.review_count ?? 0)
//                    dbObj.colors = product.colors?.toData()
//                    dbObj.category_id = product.category_id
//                    if let cardOfferIds = product.card_offer_ids {
//                        print(cardOfferIds.joined(separator: ","))
//                        dbObj.card_offers_ids = cardOfferIds.joined(separator: ",")
//                    }
//                }
//            }
//            
//            dbManager.saveContext(managedObjectContext: managedContext) { result in
//                switch result {
//                case .success(_):
//                    completionHandler(.success(true))
//                default:
//                    completionHandler(.success(false))
//                }
//            }
//        }
//    }
//    
//    //MARK: Update favourite for products
//    
//    public func updateProduct(withId productId: String, isFavourite: Bool, completionHandler: @escaping(Result<Bool, Error>) -> Void) {
//        let managedContext = dbManager.persistentContainer.viewContext
//        
//        let fetchRequest: NSFetchRequest<ProductData> = ProductData.fetchRequest()
//        fetchRequest.predicate = DBQueries.filterBy(productId: productId)
//        
//        do {
//            let results = try managedContext.fetch(fetchRequest)
//            
//            if let productToUpdate = results.first {
//                productToUpdate.isFavourite = isFavourite
//
//                dbManager.saveContext(managedObjectContext: managedContext) { result in
//                    switch result {
//                    case .success(_):
//                        completionHandler(.success(true))
//                    case .failure(let error):
//                        completionHandler(.failure(error))
//                    }
//                }
//            } else {
//                completionHandler(.success(false))
//            }
//            
//        } catch let error as NSError {
//            completionHandler(.failure(error))
//        }
//    }
//    
//    func setupCardOffersFetchedResultsController() -> NSFetchedResultsController<CardOfferData>{
//        let fetchRequest : NSFetchRequest<CardOfferData> = CardOfferData.fetchRequest()
//        let context = DBManager.shared.persistentContainer.viewContext
//        let sortDescriptor = NSSortDescriptor(key: "card_name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        let cardOffersFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do{
//            try cardOffersFetchedResultsController.performFetch()
//        }catch{
//            print("failed to fetch cat")
//        }
//        return cardOffersFetchedResultsController
//    }
//    
//    func setupCategoriesFetchedResultsController() -> NSFetchedResultsController<CategoryData>{
//        let fetchRequest : NSFetchRequest<CategoryData> = CategoryData.fetchRequest()
//        let context = DBManager.shared.persistentContainer.viewContext
//        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        
//        let categoriesFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do{
//            try categoriesFetchedResultsController.performFetch()
//        }catch{
//            print("failed to fetch cat")
//        }
//        return categoriesFetchedResultsController
//    }
//    
//        
//    func setupProductFetchedResultsController(searchStr : String,categoryId : String,cardOfferId : String? = nil,sortDescriptor : String = "rating") -> NSFetchedResultsController<ProductData>{
//        
//        let fetchRequest : NSFetchRequest<ProductData> = ProductData.fetchRequest()
//        let context = DBManager.shared.persistentContainer.viewContext
//        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        fetchRequest.predicate = DBQueries.filterBy(categoryId: categoryId, searchStr: searchStr, cardOfferId: cardOfferId)
//        
//        let productFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do{
//            try productFetchedResultsController.performFetch()
//        }catch{
//            print("failed to fetch products")
//        }
//        
//        return productFetchedResultsController
//    }
//
//    func setupProductFetchedResultsController(categoryId : String,cardOfferId : String? = nil,sortDescriptor : String = "rating") -> NSFetchedResultsController<ProductData>{
//        
//        let fetchRequest : NSFetchRequest<ProductData> = ProductData.fetchRequest()
//        let context = DBManager.shared.persistentContainer.viewContext
//        let sortDescriptor = NSSortDescriptor(key: sortDescriptor, ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        fetchRequest.predicate = DBQueries.filterBy(categoryId: categoryId)
//        
//        if let _cardOfferId = cardOfferId{
//            fetchRequest.predicate = DBQueries.filterBy(cardOfferId: _cardOfferId, categoryId: categoryId)
//        }
//        
//        let productFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//        
//        do{
//            try productFetchedResultsController.performFetch()
//        }catch{
//            print("failed to fetch products")
//        }
//        
//        return productFetchedResultsController
//    }
//    
}
