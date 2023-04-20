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
import CoreData

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
        Card.data = []
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
    
    
    lazy var persistentContainer: NSPersistentContainer = {
          /*
           The persistent container for the application. This implementation
           creates and returns a container, having loaded the store for the
           application to it. This property is optional since there are legitimate
           error conditions that could cause the creation of the store to fail.
          */
          let container = NSPersistentContainer(name: "SwiftUI_Experiment")
          container.loadPersistentStores(completionHandler: { (storeDescription, error) in
              if let error = error as NSError? {
                  // Replace this implementation with code to handle the error appropriately.
                  // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                   
                  /*
                   Typical reasons for an error here include:
                   * The parent directory does not exist, cannot be created, or disallows writing.
                   * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                   * The device is out of space.
                   * The store could not be migrated to the current model version.
                   Check the error message to determine what the actual problem was.
                   */
                  fatalError("Unresolved error \(error), \(error.userInfo)")
              }
          })
          return container
      }()

      // MARK: - Core Data Saving support
      func saveContext () {
          let context = persistentContainer.viewContext
          if context.hasChanges {
              do {
                  try context.save()
              } catch {
                  // Replace this implementation with code to handle the error appropriately.
                  // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                  let nserror = error as NSError
                  fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
              }
          }
      }

}


// MARK:- Notification names
extension Notification.Name {
    
    /// Notification when user successfully sign in using Google
    static var signInGoogleCompleted: Notification.Name {
        return .init(rawValue: #function)
    }
}

