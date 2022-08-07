//
//  AddImageViewModels.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation
import UIKit
import CryptoKit


class AddImageViewModel: ObservableObject {
    
    let keyStore = KeyStoreManager()
    
    @Published var image:UIImage? = nil
    @Published  var isImagePicker = false
    @Published var isNewAddPhoto  = false
    
    func saveImages(folderVM:FolderViewModel,images:[UIImage],completion: @escaping (Bool) -> Void) {
        
        let imageData:[Data] = images.map { image in
            image.jpegData(compressionQuality: 1) ?? Data()
        }
        
        // Saving in background Threads
        DispatchQueue.global().async {
            
            let backgroundContext = CoreDataManager.shared.persistentContainer.newBackgroundContext()
            
            backgroundContext.performAndWait {
                
                do {
                   let folder =  try backgroundContext.existingObject(with: folderVM.folderId) as? Folder
                    
                    for data in imageData {
                        let image = ImageModel(context: backgroundContext)
                        
                        // doing encryption of image and getting encrypted Data Back
                        
                        let encryptedImageData = try? self.saveEncryptedImage(data: data)
                        
                        image.imageData = encryptedImageData
                        image.folder = folder
                        image.time = Date()
                        
                    }
                    // Saving Data in core data
                    try? backgroundContext.save()
                    
                }catch {
                  print("Unable to load folder")
                }
            }
            // updating ui in main thread
            DispatchQueue.main.async {
               completion(true)
            }
        }
    }
    
    
    // Saving a enrypted Image in a CoreData
    func saveEncryptedImage(data:Data) throws -> Data  {
        
        // getting account from userDefaults
        guard let account = UserDefaults.standard.string(forKey: Constanst.accountKey.rawValue) else {
            return Data()
        }
        
        // getting a key from keyChain
        let keyfromKeyChain:SymmetricKey = try keyStore.getKey(account: account)
        
        // ecnrypt data using Crypto algorithm using symmetric key
        let sealedBoxData = try! ChaChaPoly.seal(data, using: keyfromKeyChain).combined
        
        print("Encrypted Data  \(sealedBoxData)")
        
        return sealedBoxData
    }
    
    
}
