//
 //  CreateNewMessageView.swift
 //  LBTASwiftUIFirebaseChat
 //
 //  Created by Brian Voong on 11/16/21.
 //

 import SwiftUI
 import SDWebImageSwiftUI
 import Foundation

 class CreateNewMessageViewModel: ObservableObject {
     @State private var matches = [String()]
     @Published var data2 = String()
     @Published var users = [ChatUser]()
     @Published var errorMessage = ""
     //@Published var emails = String()
     init() {
         fetchAllUsers()
     }




     func assign(match: String){
         matches.append(match)
     }



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

 struct CreateNewMessageView_Previews: PreviewProvider {
     static var previews: some View {
 //        CreateNewMessageView()
         messagesTemp()
     }
 }
