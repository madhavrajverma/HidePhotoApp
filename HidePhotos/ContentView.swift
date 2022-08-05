//
//  ContentView.swift
//  HidePhotos
//
//  Created by Lakshya  Verma on 01/08/22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            FoldersListView()
                .tabItem {
                    VStack {
                        Image(systemName: "house")
                        Text("Home")
                    }
                }
            
            Profile()
                .tabItem {
                    VStack {
                        Image(systemName: "person")
                        Text("Profile")
                    }
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
