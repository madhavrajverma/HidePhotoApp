//
//  EmptyView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 06/08/22.
//

import SwiftUI

struct EmptyView: View {
    let image:String
    let title:String
    var body: some View {
        VStack {
            
            
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(maxWidth:.infinity)
                .padding()
               
        
            
            Text("Create a tapping on the circle below")
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
        }
    }
}

struct EmptyView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView(image: "empty", title: "Add New Folder")
    }
}
