//
//  PhotosListView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import SwiftUI

struct PhotosListView: View {
    let column:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    
    @StateObject var addImageVM = AddImageViewModel()
    @StateObject var imageListVM = ImageListViewModel()
    @ObservedObject var folderListVM: FolderListViewModel
    @State private var passwordValidteView: Bool = true
    @State private var isValidPassword: Bool = false
    
    
    
    let folder: FolderViewModel
    
    var body: some View {
        
        ZStack(alignment: passwordValidteView ? .center : .bottomTrailing) {
            
            if imageListVM.imageViewModel.isEmpty {
                EmptyView(image: "emptyImage", title: "Add a New Image")
            }else {
                ScrollView(.vertical,showsIndicators: false) {
                    LazyVGrid(columns: column) {
                        ForEach(imageListVM.imageViewModel,id:\.imageId) { image in
                            NavigationLink(destination: PhotoDetailView(imageVM: image), label: {
                               PhotosListRow(imageVm: image)
                                    .padding()
                            })
                        }
                        
                    }
                }
                .blur(radius: passwordValidteView ?  16 : 0)
            }
            
         
            
            if passwordValidteView {
                PasswordValidateView(passwordValidteView:$passwordValidteView,folderListVM: folderListVM,folder: folder)
                    .transition(.scale)
            }
            
            NavigationLink(destination:  AddPhotosView(addImageVM: addImageVM, imageListVM: imageListVM, folder: folder),isActive: $addImageVM.isNewAddPhoto) {
                Text("")
            }
            
            if !passwordValidteView {
                Button(action:{
                    addImageVM.isNewAddPhoto = true
                }) {
                    Image(systemName: "plus")
                        .resizable()
                        .renderingMode(.template)
                        .frame(width: 32, height: 32)
                        .padding()
                }.background(Color("btnColor"))
                    .foregroundColor(.white)
                    .clipShape(Circle())
                    .padding()
            }
            
            
        }
        .onAppear {
            imageListVM.fetchImages(folder: folder)
            print("Hello")
        }
        .navigationTitle("Your Photos")        
    }
}

struct PhotosListView_Previews: PreviewProvider {
    static var previews: some View {
        PhotosListView(folderListVM: FolderListViewModel(), folder: FolderViewModel(folder: Folder(context: CoreDataManager.shared.viewContext)))
    }
}


struct PhotosListRow : View {
    let imageVm:ImageViewModel
    var body: some View {
        VStack{
            Image(uiImage: imageVm.uiImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
        }
    }
}
