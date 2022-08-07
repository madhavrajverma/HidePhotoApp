//
//  FoldersListView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 04/08/22.
//

import SwiftUI

enum  GridType {
    case list
    case grid
}

struct FoldersListView: View {
    
    let column:[GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    @State private var editFolder:Bool = false
   
    @StateObject var folderListVM = FolderListViewModel()
    @State private var gridType: GridType = .grid
    @State private var showAddFolder = false
   
    
    var body: some View {
        NavigationView {
            ZStack(alignment:.bottomTrailing) {
                
                if folderListVM.folders.isEmpty {
                    EmptyView(image: "empty", title: "Add New Folder")
                }else {
                    ScrollView(.vertical,showsIndicators: false) {
                        HStack {
                            Spacer()
                            HStack(spacing:10) {
                                Button(action: {
                                    withAnimation {
                                        gridType = .grid
                                    }
                                }) {
                                    Image(systemName: "square.grid.2x2")
                                        .font(.largeTitle)
                                        .foregroundColor(gridType == .grid ? Color("btnColor") : Color.gray)
                                        
                                }
                                
                                Button(action: {
                                    withAnimation {
                                        gridType = .list
                                    }
                                }) {
                                    Image(systemName: "list.bullet")
                                        .font(.largeTitle)
                                        .foregroundColor(gridType == .list ? Color("btnColor") : Color.gray)
                                }
                            }
                        }
                        .padding(.trailing)
                        
                        HStack {
                            Spacer()
                            Button(action:{
                                editFolder.toggle()
                            }){
                                Text(editFolder ? "Done" : "Edit")
                                    .font(.body)
                                    .fontWeight(.bold)
                                    .foregroundColor(Color("btnColor"))
                                    
                            }
                            .disabled(folderListVM.folders.isEmpty)
                        }.padding()
                        
                        if gridType == .grid {
                            gridView
                             
                        }else {
                            listView
                        }
                      
                    }
                }
               
                Button(action:{
                    showAddFolder.toggle()
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
            .sheet(isPresented: $showAddFolder,onDismiss: {
                folderListVM.fetchAllFolders()
            }, content: {
                AddFolderView()
            })
            .onAppear {
                folderListVM.fetchAllFolders()
            }
            .navigationTitle(folderListVM.folders.isEmpty ? "HidePhoto"  : "Your Files")
        }
    }
    
    var gridView:some View {
        LazyVGrid(columns: column) {
            ForEach(folderListVM.folders,id:\.folderId) { folder in
                
                if editFolder {
                  GridFolderView(folderListVM: folderListVM, editFolder: $editFolder, folder: folder)
                        .padding()
                } else {
                    NavigationLink(destination: PhotosListView(folderListVM: folderListVM, folder: folder)) {
                        GridFolderView(folderListVM: folderListVM, editFolder: $editFolder, folder: folder)
                            .padding()
                      
                    }
                }
            }
           
        }
    }
    
    var listView : some View {
            ForEach(folderListVM.folders,id:\.folderId) { folder in
            
                if editFolder {
                    ListFolderView(folderListVM: folderListVM, editFolder: $editFolder, folder: folder)
                        .padding(.horizontal)
                }else {
                    NavigationLink(destination: PhotosListView(folderListVM: folderListVM, folder: folder)) {
                        ListFolderView(folderListVM: folderListVM, editFolder: $editFolder, folder: folder)
                            .padding(.horizontal)
                       
                    }
                }
                
                
                
    }
}
    
   
}
    

struct FoldersListView_Previews: PreviewProvider {
    static var previews: some View {
        FoldersListView()
    }
}


struct GridFolderView: View {
    @ObservedObject var folderListVM : FolderListViewModel
    @Binding var editFolder:Bool
    let folder: FolderViewModel
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment:.leading,spacing: 20){
                Image(folder.folderType.rawValue)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(10)
                HStack(spacing:20) {
                    Circle()
                        .fill(folder.folderType.fill)
                        .frame(width:20,height: 20)
                    Text(folder.name)
                        .font(.headline)
                        .fontWeight(.semibold)
                }
            }
            
            if editFolder {
                Button(action: {
                    folderListVM.deleteFolder(folderVM: folder)
                    folderListVM.fetchAllFolders()
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }
    }
}


struct ListFolderView: View {
    @ObservedObject var folderListVM : FolderListViewModel
    @Binding var editFolder:Bool
    let folder: FolderViewModel
    var body: some View {
        HStack(spacing:20){
            Image(folder.folderType.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 100)
            
            Text(folder.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            Circle()
                .fill(folder.folderType.fill)
                .frame(width:24,height: 24)
            
            if editFolder {
                Button(action: {
                    folderListVM.deleteFolder(folderVM: folder)
                    folderListVM.fetchAllFolders()
                }) {
                    Image(systemName: "trash")
                        .font(.title)
                        .foregroundColor(.red)
                }
            }
        }
        
        
    }
}
