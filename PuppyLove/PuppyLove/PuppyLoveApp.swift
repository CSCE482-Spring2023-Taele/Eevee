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
    var body: some Scene {
        WindowGroup {
            LoginView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url) }
        }
    }
}
