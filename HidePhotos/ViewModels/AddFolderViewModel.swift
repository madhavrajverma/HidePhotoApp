//
//  AddFolderViewModel.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import Foundation
import SwiftUI

enum FolderType : String, CaseIterable{
    
    case yellowFolder = "yellow"
    case blueFolder = "Blue"
    case greenFolder = "Green"
    case lavenderFolder = "Lavender"
    case orangeFolder = "Orange"
    case redFolder =  "Red"
    case skyBolder = "SkyBlue"
    
    var fill: Color {
        switch self {
        case .yellowFolder:
          return  Color.yellow
        case .blueFolder:
            return   Color.blue
        case .greenFolder:
            return Color.green
        case .lavenderFolder:
            return Color("lavender")
        case .orangeFolder:
            return Color.orange
        case .redFolder:
            return  Color.red
        case .skyBolder:
            return Color("skyBlue")
        }
    }
    
}


class AddFolderViewModel: ObservableObject {
    
    let keyChainService = KeychainWrapper()
    
    @Published  var folderName = ""
    @Published  var password = ""
    @Published  var confirmPassword = ""
    @Published  var folderType: FolderType = .blueFolder
    @Published var isDoesNotMatchedPassword = false
    
   
    
    
  var isEnabledButton: Bool {
        return !folderName.isEmpty && !password.isEmpty && !confirmPassword.isEmpty
      }

    func saveFolder() {
        
        if password != confirmPassword {
            isDoesNotMatchedPassword = true
        }
        
        if !isDoesNotMatchedPassword {
            
            let folder = Folder(context: CoreDataManager.shared.viewContext)
            folder.name = folderName
            let account = UUID().uuidString
            folder.account = account
            folder.service = Constanst.folderAuthentictedServies.rawValue
            folder.folderType = folderType
            
            do {
                try keyChainService.storeGenericPasswordFor(account:account, service: Constanst.folderAuthentictedServies.rawValue, password: password)
                CoreDataManager.shared.save()
            } catch let error as KeychainWrapperError {
              print("Exception setting password: \(error.message ?? "no message")")
            } catch {
              print("An error occurred setting the password.")
            }
            
            
            if let password = try? keyChainService.getGenericPasswordFor(
              account:account,
              service: Constanst.folderAuthentictedServies.rawValue) {
                print(password)
            }
            
        }else {
            print("Password does not match")
        }
       
    }
    
}
