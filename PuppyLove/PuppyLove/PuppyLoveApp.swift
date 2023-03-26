//
//  PuppyLoveApp.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/14/23.
//

import SwiftUI
import GoogleSignIn

@main
struct PuppyLoveApp: App {
    @StateObject var userAuth: UserAuthModel =  UserAuthModel()
    // registering app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }
            .environmentObject(userAuth)
            .navigationViewStyle(.stack)
            
        }
    }
}
