//
//  CoreDataService.swift
//  CryptoCurrencyRates
//
//  Created by Roman Khodukin on 10/27/20.
//

import CoreData

class CoreDataService {
    
    static let shared = CoreDataService()
    
    private init(){}
    
    lazy var context: NSManagedObjectContext = {
            return persistentContainer.viewContext
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
            return persistentContainer.newBackgroundContext()
    }()
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CryptoCurrencyRates")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - CoreData Saving support
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func saveContextInBackground() {
        persistentContainer.performBackgroundTask { backgroundContext in
            if backgroundContext.hasChanges {
                do {
                    try backgroundContext.save()
                } catch {
                    let nserror = error as NSError
                    fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
                }
            }
        }
    }
    
    // MARK: - Clear Entity
    
    func clearEntityOf<T>(type: T) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type.self))
        guard let objects = try? context.fetch(fetchRequest) as? [NSManagedObject] else {
            return
        }
        for object in objects {
            context.delete(object)
        }
        saveContext()
    }
    
    // MARK: - Fetch records for Entity
    
    func fetchRecordsForEntity<T>(_ entity: T) -> [NSManagedObject] {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: entity.self))
        
        var result = [NSManagedObject]()
        
        do {
            let records = try context.fetch(fetchRequest)
            if let records = records as? [NSManagedObject] {
                result = records
            }
        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }
    
    // MARK: - Getting path to Database
    
    func applicationDocumentsDirectory() {
        if let url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).last {
            print("📂 CoreData Path 📂\n\(url.absoluteString)")
        }
    }
    
    
    // MARK: - Map & Save from Model
    
    func saveDataFrom(array: [CurrencyModel]) {
        // Loop through data and then convert to managedObject and save it
        _ = array.map { createEntityFrom(model: $0) }
        saveContext()
    }
    
    func createEntityFrom(model: CurrencyModel) -> NSManagedObject? {
        guard let entity = NSEntityDescription.insertNewObject(forEntityName: "Currency", into: context)
                as? Currency
        else { return nil }
        
        entity.id = model.id
        entity.name = model.name
        entity.symbol = model.symbol
        entity.marketCapRank = Int32(model.marketCapRank)
        entity.currentPrice = model.currentPrice
        entity.priceChangePercentage24H = model.priceChangePercentage24H ?? 0
        return entity
    }
}
