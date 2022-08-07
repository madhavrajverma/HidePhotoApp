//
//  HidePhotosApp.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 01/08/22.
//

import SwiftUI
import CryptoKit

@main
struct HidePhotosApp: App {
    
    let account = Constanst.account.rawValue
    let keyStore = KeyStoreManager()
    @AppStorage("keysSet") var keySet = false
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    storeKeys()
                    UserDefaults.standard.set(account, forKey: Constanst.accountKey.rawValue)
                }
        }
    }
    
    func storeKeys() {
        
        let key = SymmetricKey(size: .bits256)
        if !keySet {
            do {
                try? keyStore.deleteKey(account: account)
                try keyStore.storeKey(key, account: account)
                print("Key Set Succefully")
                keySet = true
            }catch {
                print("Unable to store Symmeteric Key")
            }
        }
    }
}
