//
//  AddPhotosView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 05/08/22.
//

import SwiftUI

struct AddPhotosView: View {
    
    let column:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @State private var images: [UIImage] = []
    @State private var isPhotoPickerView = false
    @State private var isSelectedFromLibrary = true
    @State private var isLoadingBar: Bool = false
    
    @ObservedObject var addImageVM: AddImageViewModel
    @ObservedObject var imageListVM: ImageListViewModel
    
    
    @Environment(\.presentationMode) var presentaionMode
    
    let folder:FolderViewModel
    
    var body: some View {
            VStack {
                if isSelectedFromLibrary {
                    
                    Button(action:{
                        isPhotoPickerView = true
                        isSelectedFromLibrary = false
                    }) {
                        Text("Add From Library")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(height:54)
                            .frame(maxWidth:.infinity)
                            .background( Color("btnColor").cornerRadius(10))
                            .padding()
                    }
                }
                else  {
                    ZStack(alignment:isLoadingBar ? .center : .bottom) {
                        
                        ScrollView(.vertical,showsIndicators: false) {
                            LazyVGrid(columns: column) {
                                ForEach(0..<images.count,id:\.self) { i in
                                    let image = images[i]
                                    VStack{
                                        Image(uiImage: image)
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                    }
                                    .padding()
                                }
                                
                            }
                            .sheet(isPresented: $isPhotoPickerView, onDismiss: {
                            
                            }) {
                                PhotoPicker(images: $images)
                            }
                        }
                        .blur(radius: isLoadingBar ? 10:0)
                        
                        if isLoadingBar {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(3)
                                .tint(.blue)
                        }
                        
                        if !isLoadingBar {
                            Button(action:{
                                isLoadingBar = true
                                addImageVM.saveImages(folderVM: folder, images: images) { val in
                                    if val {
                                        images = []
                                        presentaionMode.wrappedValue.dismiss()
                                    }
                                }
                            }) {
                                Text("Save All Photos")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .frame(height:54)
                                    .frame(maxWidth:.infinity)
                                    .background( Color("btnColor").cornerRadius(10))
                                    .padding()
                            }
                        }
                    }
                }
            }
            .navigationTitle("Selected Photos")
        
    }
}

struct AddPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotosView(addImageVM: AddImageViewModel(), imageListVM: ImageListViewModel(), folder: FolderViewModel(folder: Folder(context: CoreDataManager.shared.viewContext)))
    }
}
