//
//  XCTestCase.swift
//  FocusOnUnitTests
//
//  Created by Rafal Padberg on 13.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
import CoreData

extension XCTestCase {
    
    func setupCoreDataStack(with name: String, in bundle: Bundle) -> NSManagedObjectContext {
        
        let modelURL = bundle.url(forResource: name, withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)!
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managedObjectModel)
        
        try! persistentStoreCoordinator.addPersistentStore(ofType: NSInMemoryStoreType, configurationName: nil, at: nil, options: nil)
        let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return managedObjectContext
    }
}
