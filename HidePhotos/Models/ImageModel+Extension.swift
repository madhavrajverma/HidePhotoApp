//
//  ImageModel+Extension.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation
import CoreData

extension ImageModel {
    
    static func getAllImages(id:NSManagedObjectID) -> [ImageModel] {
        let request:NSFetchRequest<ImageModel> = ImageModel.fetchRequest()
        request.predicate = NSPredicate(format: "folder = %@", id)
        request.sortDescriptors  = [NSSortDescriptor(key: "time", ascending: false)]
        
        do {
            return  try CoreDataManager.shared.viewContext.fetch(request)
        }catch {
            print("Unable To fetch movies form databse")
            return []
        }
    }
    
    static func imageById(id:NSManagedObjectID) -> ImageModel? {
        do {
            return try CoreDataManager.shared.viewContext.existingObject(with: id) as? ImageModel
        }catch {
            return nil
        }
    }
    
    static func delete(image:ImageModel) {
             CoreDataManager.shared.viewContext.delete(image)
    }
    
}
