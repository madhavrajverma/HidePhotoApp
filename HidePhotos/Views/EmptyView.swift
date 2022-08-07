//
//  EmptyView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 06/08/22.
//

import SwiftUI

struct EmptyView: View {
    var body: some View {
        VStack {
            
            
            Text("Add New Folder")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.gray)
            
            Image("empty")
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
        EmptyView()
    }
}
