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
    var profilePicture: UIImage
}

struct Dog {
    var name: String
    var age: String
    var activityLevel: Double
    var bio: String
    var profilePicture: Data
    var vaccinated: Bool
    var fixed: Bool
}

struct ContentView: View {
    var body: some View {
        NavigationView {
            SignUpView()
        }.navigationTitle("Sign Up")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
