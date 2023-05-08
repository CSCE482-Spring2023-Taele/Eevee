//
//  ChatUser.swift
//  LBTASwiftUIFirebaseChat
//
///  Created by Brian Voong on 11/16/21.
//
///  Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat
import FirebaseFirestoreSwift
/**
 Chat user struct used to keep track of the info of the current signin user
 Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat

 */
struct ChatUser: Codable, Identifiable {
    /**
     ID of the current user within the code
     */
    @DocumentID var id: String?
    /**
        ID of the user in the database
     */
    var uid,/**
             email of the current user
             */
        email: String
    //var fromName, fromDog: String
}


