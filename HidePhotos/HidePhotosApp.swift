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
    
    @Environment(\.scenePhase) var scenePhase
    let account = Constanst.account.rawValue
    let keyStore = KeyStoreManager()
    
    @AppStorage("keysSet") var keySet = false
    @AppStorage("isAuthenticated") var isAuthenticated: Bool = false
    
    var body: some Scene {
        WindowGroup {
            if isAuthenticated {
                ContentView()
                    .onAppear {
                        storeKeys()
                        UserDefaults.standard.set(account, forKey: Constanst.accountKey.rawValue)
                    }
                    .onChange(of: scenePhase) { newPhase in
                                    if newPhase == .active {
                                        print("Active")
                                    } else if newPhase == .inactive {
                                      isAuthenticated = false
                                        
                                    } else if newPhase == .background {
                                        isAuthenticated = false
                                    }
                                }
                    .onDisappear {
                        isAuthenticated = false
                        
                    }
            } else {
                AuthenticationView(isAuthenticated: $isAuthenticated)
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
