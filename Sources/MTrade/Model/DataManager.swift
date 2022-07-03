//
//  DataManager.swift
//  
//
//  Created by Vsevolod Migdisov on 03.07.2022.
//

import CoreData

struct DataManager {
    
    static func find<T: NSManagedObject>(id: String) -> [T]? {
        guard let managedObjectContext = MTrade.managedObjectContext else { return nil }
        guard let entityName = T.entity().name else { return nil }
        let fetchRequest = NSFetchRequest<T>(entityName: entityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        guard let result = try? managedObjectContext.fetch(fetchRequest) else { return nil }
        return result
    }
    
    static func fetchRequest<T: NSManagedObject>(_ predicate: NSPredicate, sort: [String] = [String]()) -> NSFetchRequest<T> {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entity().name!)
        fetchRequest.sortDescriptors = sort.map { NSSortDescriptor(key: $0, ascending: true) }
        fetchRequest.predicate = predicate
        return fetchRequest
    }
    
    @discardableResult
    static func update<T: NSManagedObject>(id: String, _ completion: (T) -> Void) -> T? {
        guard let managedObjectContext = MTrade.managedObjectContext else { return nil }
        var object: T?
        let records = DataManager.find(id: id)
        if (records?.count ?? 0) == 0 {
            // Objects with the id are not found. Create new Object.
            object = T(context: managedObjectContext)
        } else {
            // Objects with the id are found.
            guard let objects = records as? [T] else { return nil }
            object = objects.first
            for record in objects {
                // Delete other Objects with the id as they are considering as duplicates.
                if record != object { managedObjectContext.delete(record) }
            }
        }
        guard let object = object else { return nil }
        completion(object)
        try? managedObjectContext.save()
        return object
    }
}

extension NSPredicate {
    static var all: NSPredicate { NSPredicate(value: true) }
}
