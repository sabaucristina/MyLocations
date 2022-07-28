//
//  CoreDataClient.swift
//  MyLocationsMVC
//
//  Created by Sabau Cristina on 01/03/2022.
//

import Foundation
import CoreData

protocol CoreDataClientProtocol: AnyObject {
    func readLocations() -> [Location]
    func readLocation(with id: String) -> Location?
    func insertOrUpdateLocation(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    )
    func deleteLocation(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    )
}

final class CoreDataClient: CoreDataClientProtocol {
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MyLocationsMVC")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var managedObjectContext: NSManagedObjectContext {
//        Self.persistentContainer.viewContext
        CoreDataClient.persistentContainer.viewContext
    }
    
    func readLocations() -> [Location] {
        managedObjectContext.performAndWait {
            let fetchRequest = LocationDB.fetchRequest()

            guard let locationsDB = try? managedObjectContext.fetch(fetchRequest) else {
                return []
            }
            
            return locationsDB.compactMap { $0.getDto() }
        }
    }
    
    func readLocation(with id: String) -> Location? {
        getLocationDBModel(id: id)?.getDto()
    }
    
    func insertOrUpdateLocation(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        let locationDB = getLocationDBModel(id: location.id) ?? LocationDB(context: managedObjectContext)
        
        managedObjectContext.saveOrRollback(
            changes: {
                locationDB.update(with: location)
            },
            completion: completion
        )
    }
    
    func deleteLocation(
        location: Location,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let location = getLocationDBModel(id: location.id) else {
            return completion(.success(()))
        }
        
        managedObjectContext.saveOrRollback(
            changes: { [weak managedObjectContext] in
                managedObjectContext?.delete(location)
            },
            completion: completion
        )
    }
}

private extension CoreDataClient {
    func getLocationPredicate(with id: String) -> NSPredicate {
        return NSPredicate(format: "id == %@", id)
    }
    
    func getLocationDBModel(id: String) -> LocationDB? {
        let fetchRequest = LocationDB.fetchRequest()
        
        fetchRequest.predicate = getLocationPredicate(with: id)
        fetchRequest.fetchLimit = 1
        
        return managedObjectContext.performAndWait {
            try? managedObjectContext.fetch(fetchRequest).first
        }
    }
}

extension NSManagedObjectContext {
    func saveOrRollback(
        changes: @escaping () -> Void,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        perform {
            do {
                changes()
                try self.save()
                DispatchQueue.main.async {
                    completion(.success(()))
                }
            } catch {
                assertionFailure(error.localizedDescription)
                self.rollback()
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
}
