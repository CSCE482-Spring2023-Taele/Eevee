//
//  AppDelegate.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/15/23.
//

import Foundation
import UIKit
import GoogleSignIn
import FirebaseCore

class AppDelegate: UIResponder, UIApplicationDelegate
{
    
    // View https://developers.google.com/identity/sign-in/ios/sign-in#swift_1 as reference
    func application(_ app: UIApplication,
      open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool
    {
      var handled: Bool

      handled = GIDSignIn.sharedInstance.handle(url)
      if handled {
        return true
      }
      // Handle other custom URL types.
      // If not handled by this app, return false.
      return false
    }
    
    func application(_ application: UIApplication,
      didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool
    {
        //FirebaseApp.configure()
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
        if error != nil || user == nil {
          // Show the app's signed-out state.
        } else {
          // Show the app's signed-in state.
        }
        UserDefaults.standard.removeObject(forKey: "cards")
      }
      return true
    }
    
}


// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}
