//
//  PersistenceManager.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation


import CoreData
import SwiftUI

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataManager()
    
    private init() {
        
        persistentContainer = NSPersistentContainer(name: "HidePhoto")
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to initialize Core Data \(error)")
            }
        }
        
    }
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save() {
          
            if viewContext.hasChanges {
                do {
                    try viewContext.save()
                } catch {
                    // Show some error here
                }
            }
        }
    
}
