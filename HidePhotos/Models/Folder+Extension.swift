//
//  Folder+Extension.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import Foundation
import CoreData

extension Folder {
    
    var folderType: FolderType {
        get { return FolderType.init(rawValue: String(folderColor ?? "")) ?? .blueFolder}
        set { folderColor = String(newValue.rawValue) }
    }
    
    static func folderById(id:NSManagedObjectID) -> Folder? {
        do {
            return try CoreDataManager.shared.viewContext.existingObject(with: id) as? Folder
        }catch {
            return nil
        }
    }
    
    static func getAllFolders() -> [Folder] {
        let request:NSFetchRequest<Folder> = Folder.fetchRequest()
//        request.sortDescriptors  = [NSSortDescriptor(key: "time", ascending: false)]
        
        do {
            return  try CoreDataManager.shared.viewContext.fetch(request)
        }catch {
            print("Unable To fetch movies form databse")
            return []
        }
    }
    
    static func delete(folder:Folder) {
             CoreDataManager.shared.viewContext.delete(folder)
        CoreDataManager.shared.save()
    }
    
    
}
