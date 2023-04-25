//
//  PuppyLoveApp.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/14/23.
//

import SwiftUI
import GoogleSignIn
import Amplify
import AWSCognitoAuthPlugin
import AWSS3StoragePlugin

@main
struct PuppyLoveApp: App {
    @StateObject var userAuth: UserAuthModel =  UserAuthModel()
    // registering app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    init() {
            configureAmplify()
        }
        
        private func configureAmplify() {
            do {
                try Amplify.add(plugin: AWSCognitoAuthPlugin())
                try Amplify.add(plugin: AWSS3StoragePlugin())
                
                try Amplify.configure()
                print("Successfully configured Amplify")
                
            } catch {
                print("Could not configure Amplify", error)
            }
        }
    
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
