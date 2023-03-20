//
//  ContentView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/14/23.
//

import SwiftUI

struct User {
    var name: String
    var age: Int
    var bio: String
    var gender: String
}

struct Dog {
    var name: String
    var age: String
    var activityLevel: Double
}

struct ContentView: View {
    var body: some View {
        SignUpView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
