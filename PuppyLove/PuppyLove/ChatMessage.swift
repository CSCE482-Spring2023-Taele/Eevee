///
//  ChatMessage.swift
//  LBTASwiftUIFirebaseChat
///
///  Created by Truitt Millican
///

import Foundation
import FirebaseFirestoreSwift
/**
 Format of a chat message
 */
struct ChatMessage: Codable, Identifiable {
    /**
        id of the message as a string
     */
    @DocumentID var id: String?
    /**
        fromId is the user that sent the message
     */
    let fromId,
        /**
         id of the user that the message was sent to
         */
        toId,
        /**
                message text
         */
        text: String
    /**
     when the message was sent
     */
    let timestamp: Date
   // var fromName, fromDog: String
    
}
