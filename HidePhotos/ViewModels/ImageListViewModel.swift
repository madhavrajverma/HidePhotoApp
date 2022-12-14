//
//  ImageListViewModel.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation
import CoreData
import SwiftUI
import CryptoKit

class ImageListViewModel:ObservableObject {
    
    let keyStore = KeyStoreManager()
    
    @Published var imageViewModel: [ImageViewModel] = []
    
    func  fetchImages(folder:FolderViewModel) {
        DispatchQueue.main.async {
            self.imageViewModel = ImageModel.getAllImages(id: folder.folderId).map(ImageViewModel.init)
        }
    }
    
    
    func decrytImageFormData(encyptedData:Data) throws -> UIImage {
        
        guard let account = UserDefaults.standard.string(forKey: Constanst.accountKey.rawValue) else {
            return UIImage()
        }
        
        // getting key from key chain
        let keyfromKeyChain:SymmetricKey = try keyStore.getKey(account: account)
        
        // make a seled box from enryptedData
        let sealedBox = try! ChaChaPoly.SealedBox(combined: encyptedData)
        
        // decrypt Data using key
        let decryptedData = try! ChaChaPoly.open(sealedBox, using: keyfromKeyChain)
        
        print("Decrypted Data \(decryptedData)")
        return UIImage(data: decryptedData) ?? UIImage()
    }
    
    func getImage(encyptedData:Data) -> UIImage {
        do {
           return try decrytImageFormData(encyptedData: encyptedData)
        }catch {
            print("Unable to catch error")
        }
        return UIImage()
    }
    
}

struct ImageViewModel {
    
    let image : ImageModel
    let keyStore = KeyStoreManager()
    
    var imageId: NSManagedObjectID {
        return image.objectID
    }
    
    var imageData: Data {
        return self .image.imageData ?? Data()
    }
    
    
    // decrypt Image from encrypted Data
    
 
}
