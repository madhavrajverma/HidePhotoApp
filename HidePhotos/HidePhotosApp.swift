//
//  HidePhotosApp.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 01/08/22.
//

import SwiftUI

@main
struct HidePhotosApp: App {
    let account = "com.hidephoto.genericpassword.key"
    var body: some Scene {
        WindowGroup {
            NewSwiftView()
                .onAppear {
                    UserDefaults.standard.set(account, forKey: "account")
                }
        }
    }
}
