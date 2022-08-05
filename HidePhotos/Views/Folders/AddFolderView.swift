//
//  AddFolderView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import SwiftUI



struct AddFolderView: View {
    
    @StateObject var addFolderVM = AddFolderViewModel()
    @Environment(\.presentationMode) var presentaionMode
    
    var body: some View {
        NavigationView {
            VStack(alignment:.leading,spacing: 20) {
                DetailEnterView(isSecure: false, text: $addFolderVM.folderName, title: "Enter Folder Name", placeHolder: "Enter Folder Name")
                    .padding(.top,40)
                DetailEnterView(isSecure: true, text: $addFolderVM.password, title: "Enter Password", placeHolder: "Enter Your Password")
                DetailEnterView(isSecure: true, text: $addFolderVM.confirmPassword, title: "Confirm Password", placeHolder: "Confirm Password")
                
                VStack(alignment:.leading) {
                    Text("Tags")
                        .font(.title3)
                        .fontWeight(.bold)
                    
                    HStack {
                        ForEach(FolderType.allCases,id:\.self) { type in
                            ZStack {
                                Circle()
                                    .fill(type.fill)
                                    .frame(width:30,height: 30)
                                Circle()
                                    .stroke(type == addFolderVM.folderType ? Color.black : Color.clear,lineWidth: 3)
                                    .frame(width:35,height: 35)
                            }.onTapGesture {
                                addFolderVM.folderType = type
                                    }
                        }
                    }.frame(height:50)
                }
                
                HStack {
                    Spacer()
                    Button(action:{
                        addFolderVM.saveFolder()
                        presentaionMode.wrappedValue.dismiss()
                    }) {
                        Text("Save Folder")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding()
                            .frame(height:56)
                            .padding(.horizontal)
                            .background(addFolderVM.isEnabledButton ? Color("btnColor").cornerRadius(10) : Color("btnColor").opacity(0.5).cornerRadius(10))
                    }
                    .disabled(!addFolderVM.isEnabledButton)
                    
                    Spacer()
                }
                
                Spacer()
            } .padding(.horizontal)
                .navigationTitle("Add New Folder")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button(action: {
                            presentaionMode.wrappedValue.dismiss()
                        }) {
                            Text("Back")
                                .fontWeight(.bold)
                        }
                    }
                }
        }
    }
}


struct AddFolderView_Previews: PreviewProvider {
    static var previews: some View {
        AddFolderView()
    }
}



struct DetailEnterView: View {
    var isSecure : Bool
    @Binding var text:String
    var title :String
    var placeHolder:String
    var body: some View {
        VStack(alignment:.leading) {
            Text(title)
                .font(.title3)
                .fontWeight(.bold)
            
            if isSecure {
                SecureField(placeHolder,text: $text)
                    .modifier(CustomTextFieldModifier())
            }else {
                TextField(placeHolder,text: $text)
                    .disableAutocorrection(true)
                    .modifier(CustomTextFieldModifier())
            }
        }
       
    }
}
