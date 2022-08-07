//
//  AuthenticationView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 07/08/22.
//

import SwiftUI
import LocalAuthentication



func getBiometricType() -> String {
  let context = LAContext()

  _ = context.canEvaluatePolicy(
    .deviceOwnerAuthenticationWithBiometrics,
    error: nil)
  switch context.biometryType {
  case .faceID:
    return "faceid"
  case .touchID:
    // In iOS 14 and later, you can use "touchid" here
    return "lock"
  case .none:
    return "lock"
  @unknown default:
    return "lock"
  }
}


struct AuthenticationView: View {
   
    @AppStorage("isBiometricAuthenticationEnabled") var isBiometricAuthenticationEnabled = false
    
    
    @State private var isBiometricSucces = true
    @State private var password:String = ""
    @State private var confirmPassword:String = ""
    @AppStorage("isNew") private var isNew : Bool = true
    @State var isDoesNotMatchedPassword = false
    @Binding var isAuthenticated : Bool
    
    
    let keyChainService = KeychainWrapper()
    
    var body: some View {
        VStack {
            
            if !isBiometricSucces || isNew || !isBiometricAuthenticationEnabled {
                VStack(spacing:50) {
                    
                    HStack {
                        VStack(alignment:.leading, spacing:0) {
                            Text("Welcome to")
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.gray)
                            
                            Text("HidePhoto")
                                .font(.largeTitle)
                                .fontWeight(.semibold)
                                .foregroundColor(Color("btnColor"))
                        }
                        Spacer()
                    }
                    
                    Image("lock")
                        .resizable()
                        .scaledToFit()
                        .frame(height:isNew ? 100 : 160)
                    
                    VStack(spacing:30){
                        
                        VStack(alignment:.leading,spacing: 10) {
                            Text("Enter password")
                                .font(.body)
                                .fontWeight(.bold)
                                .foregroundColor(.black.opacity(0.6))
                            
                            SecureField("Enter Password", text: $password)
                                .modifier(CustomTextFieldModifier())
                            
                            if isNew {
                                Text("Confirm password")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(.black.opacity(0.6))
                                
                                SecureField("Enter Password", text: $confirmPassword)
                                    .modifier(CustomTextFieldModifier())
                            }
                        }
                        
                        if isNew {
                            saveButton
                        }else {
                            
                            doneButton
                        }
                        
                    }
                    .padding()
                    .frame(height:isNew ? 300 :200)
                    .padding(.vertical)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6)
                                 )
                    )
                    
                    Spacer()
                }
                .padding()
            }
        }
        .onAppear {
            if !isNew && isBiometricAuthenticationEnabled {
                tryBiometricAuthentication()
            }
        }
    }
    
    var saveButton: some View {
        Button(action : {
            
            if password != confirmPassword {
                isDoesNotMatchedPassword = true
            }else {
                try? keyChainService.deleteGenericPasswordFor(account: Constanst.mainAccount.rawValue, service: "login")
                
                try? keyChainService.storeGenericPasswordFor(account: Constanst.mainAccount.rawValue, service: "login", password: password)
            }
            isNew = false
            isBiometricSucces = false
        }) {
            Text("Save")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(height:56)
                .padding(.horizontal)
                .background(Color("btnColor").cornerRadius(10))
            
        }
    }
    
    var doneButton : some View {
        Button(action : {
            let keyChainPassword = try? keyChainService.getGenericPasswordFor(account: Constanst.mainAccount.rawValue, service: "login")
            
            if keyChainPassword == password {
                isAuthenticated = true
            }
            
        }) {
            Text("Done")
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding()
                .frame(height:56)
                .padding(.horizontal)
                .background(Color("btnColor").cornerRadius(10))
            
        }
    }
    
    func tryBiometricAuthentication() {
      // 1
      let context = LAContext()
      var error: NSError?

      // 2
      if context.canEvaluatePolicy(
        .deviceOwnerAuthenticationWithBiometrics,
        error: &error) {
        // 3
        let reason = "Authenticate to View Your Files"
        context.evaluatePolicy(
          .deviceOwnerAuthentication,
          localizedReason: reason) { authenticated, error in
          // 4
          DispatchQueue.main.async {
            if authenticated {
              // 5
             isAuthenticated = true
            } else {
              // 6
              if let errorString = error?.localizedDescription {
                print("Error in biometric policy evaluation: \(errorString)")
                  isBiometricSucces = false
              }
           
            }
          }
        }
      } else {
        // 7
        if let errorString = error?.localizedDescription {
          print("Error in biometric policy evaluation: \(errorString)")
            isBiometricSucces = false
        }
      
      }
    }
    
}

struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView( isAuthenticated: .constant(true))
    }
}
