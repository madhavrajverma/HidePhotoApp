//
//  PasswordValidateView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import SwiftUI

struct PasswordValidateView: View {
    
    @Binding var passwordValidteView:Bool
    @ObservedObject var folderListVM: FolderListViewModel
    @State private var enteredPassword:String = ""
    @State private var wrongPasswordBorder: Bool = false
    
    let folder:FolderViewModel
    
    var isButtonDisabled:Bool {
        enteredPassword.isEmpty
    }
    
    var body: some View {
        ZStack {
            Color
                .gray
                .edgesIgnoringSafeArea(.all)
                .opacity(0.2)
                .blur(radius: 20)
            VStack(spacing:16) {
                Image("lock")
                    .resizable()
                    .frame(width: 40, height: 40)
                
                Text("Enter Your Password")
                    .font(.title)
                    .fontWeight(.semibold)
                
                SecureField("Enter Password", text: $enteredPassword)
                    .modifier(CustomTextFieldModifier(height:24,borderColor:  wrongPasswordBorder ? .red : .blue))
                
                Button(action: {
                    
                  let keyChainPassword =  folderListVM.getPasswordForFolder(folderVM: folder)
                    
                    if keyChainPassword == enteredPassword {
                        withAnimation(.easeInOut(duration: 0.5)){
                            passwordValidteView = false
                        }
                    }else {
                        wrongPasswordBorder = true
                    }
                    
                }) {
                    Text("Done")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .padding(.horizontal)
                        .frame(height:54)
                        .background(!isButtonDisabled ? Color("btnColor").cornerRadius(10) : Color("btnColor").opacity(0.5).cornerRadius(10))
                }.disabled(isButtonDisabled)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 20).fill(.white))
            .padding()
        }
    }
}

struct PasswordValidateView_Previews: PreviewProvider {
    static var previews: some View {
        PasswordValidateView(passwordValidteView: .constant(true),folderListVM: FolderListViewModel(),folder: FolderViewModel(folder: Folder(context: CoreDataManager.shared.viewContext)))
    }
}
