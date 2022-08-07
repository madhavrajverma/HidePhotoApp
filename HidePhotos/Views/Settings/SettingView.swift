//
//  SettingView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 07/08/22.
//

import SwiftUI

struct SettingView: View {
    @AppStorage("isBiometricAuthenticationEnabled") var isBiometricAuthenticationEnabled = false
    
    @State private var password =  ""
    @State private var confirmPassword = ""
    @State private var isPasswordSaveSuccesful = false
    @State private var changePassword = false
    
    let keyChainService = KeychainWrapper()
    
    var body: some View {
        NavigationView {
            VStack  {
                Form {
                    Toggle("Biometric Authentication", isOn: $isBiometricAuthenticationEnabled)
                    
                    Toggle("Change", isOn: $changePassword)
                    
                    if changePassword {
                        SecureField("Password", text: $password)
                        SecureField("Confirm Pasword", text: $confirmPassword)
                        
                        HStack {
                            Spacer()
                            Button(action : {
                                if password != confirmPassword {
                                   
                                }else {
                                    try? keyChainService.deleteGenericPasswordFor(account: Constanst.mainAccount.rawValue, service: "login")
                                    
                                    try? keyChainService.storeGenericPasswordFor(account: Constanst.mainAccount.rawValue, service: "login", password: password)
                                    isPasswordSaveSuccesful = true
                                }
                            }) {
                                Text("Save")
                                    .font(.title3)
                                    .foregroundColor(.blue)
                            }
                            Spacer()
                        }
                    }

                    
                    HStack {
                        Spacer()
                        Text("v 1.1")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                }
                .alert("", isPresented: $isPasswordSaveSuccesful) {
                    Button("Ok") {
                        changePassword = false
                        
                    }
                } message: {
                    Text("Password Updated Succesfully")
                }

                
             
            }
            .navigationTitle("Settings")
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
