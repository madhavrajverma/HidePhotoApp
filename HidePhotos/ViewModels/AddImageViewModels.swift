//
//  AddImageViewModels.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation
import UIKit


class AddImageViewModel: ObservableObject {
//  @Published  var images:[UIImage] = []
    @Published var image:UIImage? = nil
    @Published  var isImagePicker = false
    @Published var isNewAddPhoto  = false
    
    func saveImages(folderVM:FolderViewModel,images:[UIImage],completion: @escaping (Bool) -> Void) {
        
        let imageData:[Data] = images.map { image in
            image.jpegData(compressionQuality: 1) ?? Data()
        }
        
        // Saving in background thread
        DispatchQueue.global().async {
            
            let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            
            backgroundContext.performAndWait {
                
                do {
                   let folder =  try backgroundContext.existingObject(with: folderVM.folderId) as? Folder
                    
                    for data in imageData {
                        let image = ImageModel(context: backgroundContext)
                        image.imageData = data
                        image.folder = folder
                        image.time = Date()
                        
                    }
                    try? backgroundContext.save()
                    
                }catch {
                  print("Unable to load folder")
                }
            }
            DispatchQueue.main.async {
               completion(true)
            }
        }
    }
}
