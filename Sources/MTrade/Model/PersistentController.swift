//
//  PersistentController.swift
//  
//
//  Created by Vsevolod Migdisov on 03.07.2022.
//

import CoreData

/// Core Data managed object context manager.
struct PersistentController {
    
    static let shared = PersistentController()
    
    /// A container that encapsulates the persistent store stack
    let container: NSPersistentContainer
    
    init(inMemory: Bool = false) {
        
        let bundle = Bundle.module
        let modelURL = bundle.url(forResource: "mtrade", withExtension: ".momd")!
        let model = NSManagedObjectModel(contentsOf: modelURL)!
        container = NSPersistentContainer(name: "mtrade", managedObjectModel: model)
        
        // Initialize in memory store for unit tests.
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }
    
}
