//
//  FirebaseManager.swift
//  LBTASwiftUIFirebaseChat
//
//  Created by Brian Voong on 11/15/21.
//

import Foundation
import Firebase
/**
 used to interface with firebase
 */
class FirebaseManager: NSObject {
    /**
     used for authenticating with firebase
     */
    let auth: Auth
    /**
     used for accessing the storage pertaining to firebase
     */
    let storage: Storage
    /**
     used for accessing the firebase firestore db
     */
    let firestore: Firestore
    /**
     instance of chat user to keep track of pertanent user info
     */
    var currentUser: ChatUser?
    /**
     what is shared with firebase
     */
    static let shared = FirebaseManager()
    
    /**
     overrides the init to set all of the necessary info for firebase
     */
    override init() {
        FirebaseApp.configure()
        
        self.auth = Auth.auth()
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
