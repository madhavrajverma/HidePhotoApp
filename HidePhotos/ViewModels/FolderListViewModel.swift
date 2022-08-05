//
//  FolderListViewModel.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import Foundation
import CoreData

class FolderListViewModel : ObservableObject {
    
    @Published var folders : [FolderViewModel] = []
    
    func fetchAllFolders() {
        DispatchQueue.main.async {
            self.folders = Folder.getAllFolders().map(FolderViewModel.init)
        }
    }
    
    
    func getPasswordForFolder(folderVM : FolderViewModel) -> String {
        
        let kcw = KeychainWrapper()
        if let password = try? kcw.getGenericPasswordFor(
            account: folderVM.account,
            service: folderVM.service) {
          return password
        }

        return ""
    }
}

struct FolderViewModel {
    
    let folder :Folder
    
    var folderId: NSManagedObjectID {
        return folder.objectID
    }
    
    var name:String {
        return folder.name ?? ""
    }
    
    var service:String {
        return folder.service ?? ""
    }
    
    var account : String {
        return folder.account ?? ""
    }
    
    var folderType:FolderType {
        return folder.folderType
    }
    
}
