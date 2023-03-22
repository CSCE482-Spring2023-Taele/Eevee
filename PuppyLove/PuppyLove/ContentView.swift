//
//  ContentView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/14/23.
//

import SwiftUI
/*
struct ContentView: View {
    
    var body: some View {
        VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text("Hello, world!")
     }
     .padding()
     }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

*/
struct ContentView: View {
    @State private var selection = 1
    
    var body: some View {
        TabView(selection: $selection){
       /*     Categories()
                .tabItem{
                    VStack {
                        Image(systemName: "globe")
                        Text("Categories")
                    }
                }
                .tag(0)*/
            Profile()
                .font(.title)
                .tabItem{
                    VStack{
                        Image(systemName:"person")
                        Text("Profile")
                    }
                }
                .tag(0)
        }
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
