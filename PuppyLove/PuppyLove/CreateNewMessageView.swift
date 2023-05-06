///
 //  CreateNewMessageView.swift
 //  PuppyLove
 ///
 ///  Created by Truitt Millican
 ///

 import SwiftUI
 import SDWebImageSwiftUI
 import Foundation

/** #Description#
 This class serves as the model for creating the New Message View that displays the users and options when the user presses the
 "+ New Message" button on the chat page. It contains a list of matches, a ChatUser, and an error message.
 
 Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat
 
 */
 class CreateNewMessageViewModel: ObservableObject {
     /**
            List of matches that the user has made. It is a string because this list is meant to be displayed
      */
     @State private var matches = [String()]
     //@Published var data2 = String()
     /**
      List of users that can be chatted with. It is different from matches in that the type is ChatUser, allowing for messages to actually be sent
      */
     @Published var users = [ChatUser]()
     /**
            Used to keep track of any error that occurs when obtaining the matches of the user
      */
     @Published var errorMessage = ""
     //@Published var emails = String()
     /**
      Calls fetchAllUsers function when class is initialized
      */
     init() { ///
         fetchAllUsers()
     }



     /**Adds each match of the user to the list of matches in the class
      - parameters:
      - match: String is the match's email that is added to the list of matches of the user
      */
     func assign(match: String){
         matches.append(match)
     }


     /**
            fetches all of the users the macthes the users is matched with. It first grabs all of these users from the MatchAPI then appends each one to the users class variable to be used when chatting
      */
     private func fetchAllUsers() {
         //var t = MatchAPI().userEmail = FirebaseManager.shared.auth.currentUser!.email
         //var email = FirebaseManager.shared.auth.currentUser?.email
         

         //var email = "aaron@test.com"
         //var result = String()
         
         //print(self.assign)
         


         FirebaseManager.shared.firestore.collection("users")
             .getDocuments { documentsSnapshot, error in
                 if let error = error {
                     self.errorMessage = "Failed to fetch users: \(error)"
                     print("Failed to fetch users: \(error)")
                     return
                 }
                 MatchAPI.getMatches(userEmail: FirebaseManager.shared.auth.currentUser!.email!) {
                     result in
                     var parse = result.trimmingCharacters(in: CharacterSet(charactersIn: "[\"\"]"))
                     parse = parse.replacingOccurrences(of: "\"", with: "")
                     //print(parse)
                     var matches = parse.components(separatedBy: ",")
                     print(matches)
                     matches.append("trudogmill@gmail.com")
                     matches.append("tmillican6362@gmail.com")
                     matches.append("truittamillican@gmail.com")
                     print(matches)
                     documentsSnapshot?.documents.forEach({ snapshot in
                         let user = try? snapshot.data(as: ChatUser.self)
                         if user?.uid != FirebaseManager.shared.auth.currentUser?.uid {
                             matches.forEach{ match in
                             if match == user?.email{
                             //print("Hey:" + result)
                             
                             self.users.append(user!)
                             }
                             }

                         }

                     })
                 }

             }
     }
 }
/**
 struct that contains the actual display of the information in the app. It will display each of the potential chats in a button that cna be pressed that displays the chat log
 */
 struct CreateNewMessageView: View {

     let didSelectNewUser: (ChatUser) -> ()

     @Environment(\.presentationMode) var presentationMode

     @ObservedObject var vm = CreateNewMessageViewModel()

     var body: some View {
         NavigationView {
             ScrollView {
                 Text(vm.errorMessage)

                 ForEach(vm.users) { user in
                     Button {
                         presentationMode.wrappedValue.dismiss()
                         didSelectNewUser(user)
                     } label: {
                         HStack(spacing: 16) {

                             Text(user.email)
                                 .foregroundColor(Color(.label))
                             Spacer()
                         }.padding(.horizontal)
                     }
                     Divider()
                         .padding(.vertical, 8)
                 }
             }.navigationTitle("New Message")
                 .toolbar {
                     ToolbarItemGroup(placement: .navigationBarLeading) {
                         Button {
                             presentationMode.wrappedValue.dismiss()
                         } label: {
                             Text("Cancel")
                         }
                     }
                 }
         }
     }
 }
/**
 The preview provider for CreateNewMessageView. SImply takes the user to messagesTemp
 */
 struct CreateNewMessageView_Previews: PreviewProvider {
     static var previews: some View {
 //        CreateNewMessageView()
         messagesTemp()
     }
 }
