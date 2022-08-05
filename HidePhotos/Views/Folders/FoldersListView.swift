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
    
   
    @StateObject var folderListVM = FolderListViewModel()
    @State private var gridType: GridType = .grid
    @State private var showAddFolder = false
   
    
    var body: some View {
        NavigationView {
            ZStack(alignment:.bottomTrailing) {
                
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
                    
                    if gridType == .grid {
                        gridView
                         
                    }else {
                        listView
                    }
                  
                }
               
                Button(action:{
                    showAddFolder = true
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
            .navigationTitle("Your Files")
        }
    }
    
    var gridView:some View {
        LazyVGrid(columns: column) {
            ForEach(folderListVM.folders,id:\.folderId) { folder in
                NavigationLink(destination: PhotosListView(folderListVM: folderListVM, folder: folder)) {
                    GridFolderView(folder: folder)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteFolder(folderVM:folder)
                            } label: {
                               Label("Delete", systemImage: "trash")
                            }

                        }
                     .padding()
                  
                }
            }
           
        }
    }
    
    var listView : some View {
            ForEach(folderListVM.folders,id:\.folderId) { folder in
                NavigationLink(destination: PhotosListView(folderListVM: folderListVM, folder: folder)) {
                    ListFolderView(folder: folder)
                        .contextMenu {
                            Button(role: .destructive) {
                                deleteFolder(folderVM:folder)
                            } label: {
                               Label("Delete", systemImage: "trash")
                            }

                        }
                        .padding(.horizontal)
                   
                }
                
    }
}
    
    private func deleteFolder(folderVM:FolderViewModel) {
        let folder = Folder.folderById(id: folderVM.folderId)
        if let folder = folder {
            Folder.delete(folder: folder)
        }
    }
    
}
    

struct FoldersListView_Previews: PreviewProvider {
    static var previews: some View {
        FoldersListView()
    }
}


struct GridFolderView: View {
    let folder: FolderViewModel
    var body: some View {
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
    }
}


struct ListFolderView: View {
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
        }
    }
}
