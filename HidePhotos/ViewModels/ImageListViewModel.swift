//
//  ImageListViewModel.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 02/08/22.
//

import Foundation
import CoreData
import SwiftUI

class ImageListViewModel:ObservableObject {
    
    @Published var imageViewModel: [ImageViewModel] = []
    
    func  fetchImages(folder:FolderViewModel) {
        DispatchQueue.main.async {
            self.imageViewModel = ImageModel.getAllImages(id: folder.folderId).map(ImageViewModel.init)
        }
    }
    
   
}

struct ImageViewModel {
    let image : ImageModel
    
    var imageId: NSManagedObjectID {
        return image.objectID
    }
    
    var uiImage: UIImage {
        UIImage(data: image.imageData ?? Data()) ?? UIImage()
    }
}
