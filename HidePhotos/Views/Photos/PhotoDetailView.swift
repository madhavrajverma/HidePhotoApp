//
//  PhotoDetailView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 05/08/22.
//

import SwiftUI

struct PhotoDetailView: View {
    let imageVM : ImageViewModel
    @State private var isAddToLibrary: Bool = false
    @Environment(\.presentationMode) var presentaionMode
    var body: some View {
        VStack(spacing:20) {
            
            HStack {
                Spacer()
                Text("Your Photo")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
            }
            Image(uiImage: imageVM.uiImage)
                .resizable()
                .scaledToFit()
                .cornerRadius(20)
                .frame(maxWidth:.infinity)
                .padding()
            HStack {
                Spacer()
                Button(action: {
                    isAddToLibrary = true
                }) {
                    Text("Save To Photos Library")
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(height:56)
                        
                        .background( Color("btnColor").cornerRadius(10))
                }
                Spacer()
                Button(action: {
                    
                    let image = ImageModel.imageById(id: imageVM.imageId)
                    if let image = image {
                        ImageModel.delete(image: image)
                    }
                    presentaionMode.wrappedValue.dismiss()
                }) {
                    Text("Delete")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding()
                        .frame(height:56)
                        .padding(.horizontal)
                        .background( Color.red.cornerRadius(10))
                }
                Spacer()
            }
            
            Spacer()
        }
        .sheet(isPresented: $isAddToLibrary) {
            SaveToLibrarySheet(activityItems: [imageVM.uiImage], applicationActivities: nil)
        }

    }
}

struct PhotoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PhotoDetailView(imageVM: ImageViewModel(image: ImageModel(context: CoreDataManager.shared.viewContext)))
    }
}
