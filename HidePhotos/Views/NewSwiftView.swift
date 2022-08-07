//
//  NewSwiftView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 07/08/22.
//

import SwiftUI
import CryptoKit

struct NewSwiftView: View {
    @State private var data:Data?
    var body: some View {
        VStack {
            Image(uiImage: UIImage(data: data ?? Data()) ?? UIImage())
                .resizable()
                .frame(width:400,height: 300)
            Button(action:{
            try? ecrptedData()
            }) {
                Text("Do Encryption")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
            }
        }
    }
    
    func ecrptedData()  throws  {
        
        guard let account = UserDefaults.standard.string(forKey: Constanst.accountKey.rawValue) else {
            return
        }
        
        let keyStore = KeyStoreManager()
      
        
//        let key = SymmetricKey(size: .bits256)
//
//
//        try? keyStore.storeKey(key, account: account)
        
        let image = UIImage(named: "Rectangle")
        guard let data = image?.pngData()  else {
            return
        }
        
        let keyfromKeyChain:SymmetricKey = try keyStore.getKey(account: account)
        
        
        let sealedBoxData = try! ChaChaPoly.seal(data, using: keyfromKeyChain).combined
        print("Encrypted Data  \(sealedBoxData)")
        
        
        
        
        let sealedBox = try! ChaChaPoly.SealedBox(combined: sealedBoxData)
        
        let decryptedData = try! ChaChaPoly.open(sealedBox, using: keyfromKeyChain)
        
        self.data = decryptedData
       
        print("Decrypted Data\(decryptedData)")

    }
}

struct NewSwiftView_Previews: PreviewProvider {
    static var previews: some View {
        NewSwiftView()
    }
}
