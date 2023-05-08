//
//  RecentMessage.swift
//  LBTASwiftUIFirebaseChat
//
///  Created by Truitt Millican
//
// Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat
import Foundation
import FirebaseFirestoreSwift
/**
 Format of a recent message. Recent message is a separate category in the Firebase databse. It is the message that is displayed when the chatlog is not in view. It is a separate entitiry so that each message's timestamp does not need to be checked for the most recent message
 Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat

 */
struct RecentMessage: Codable, Identifiable {
    /**
        id of the message
     */
    @DocumentID var id: String?
    /**
        message text
     */
    let text,
        /**
                email of the user that sent the message
         */
        email: String
        /**
                id of the user that sent the message
         */
    let fromId,
        /**
            id of the user than needs to receive the message
         */
        toId: String
    //let profileImageUrl: String
    /**
        when the message was sent
     */
    let timestamp: Date
    //let fromName, fromDog: String
    /**
        name needing to be displayed on the chatlog
     */
    var username: String {
        email.components(separatedBy: "@").first ?? email
    }
    /**
     how long ago the message was sent
     */
    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: timestamp, relativeTo: Date())
    }
}
