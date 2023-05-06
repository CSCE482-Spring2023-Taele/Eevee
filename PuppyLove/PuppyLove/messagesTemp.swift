//
//  messagesTemp.swift
//  PuppyLove
//
///  Created by Jennifer Choudhury on 4/4/23.
//
///  Template taken from: https://www.letsbuildthatapp.com/courses/SwiftUI%20Firebase%20Chat

import SwiftUI
import SDWebImageSwiftUI
import Firebase
import FirebaseFirestoreSwift

/**
 Formatting of the inefficientmessage API response
 */
struct info: Codable{
    /**
        identification token used to identify the message in the code. Needed to iterate through each response
     */
    let id = UUID()
    /**
     User's email
     */
    let Item1: String
    /**
     User's dog
     */
    let Item2: String
    /**
     User's name
     */
    let Item3: String
}
/**
 Used to create the main messages view when the user clicks on the "bark" page
 */
class MainMessagesViewModel: ObservableObject {
    /**
     Used to display errors at any point in the code process
     */
    @Published var errorMessage = ""
    /**
     Used to keep track of the current user's info in order to display their information
     */
    @Published var chatUser: ChatUser?
    /**
     Used to keep track of the user's loggged in status. If the user logs out, it will wipe the messages so they cannot be extracted
     */
    @Published var isUserCurrentlyLoggedOut = false
    //typealias store = (email: String, userName: String, dogName: String)
    //@Published var nameDogs: [store] = []
    //@State var results = [String]()
    /**
     Init of the class. Checks to see if the user is logged in, fetches the info of the user of they are logged in, and fetches the recent messages that need to be displayed
     */
    init() {
        
        DispatchQueue.main.async {
            self.isUserCurrentlyLoggedOut = FirebaseManager.shared.auth.currentUser?.uid == nil
        }
        print(self.isUserCurrentlyLoggedOut)
        
        fetchCurrentUser()
        //print(self.chatUser?.email)
        fetchRecentMessages()
//        getMatches(userEmail: FirebaseManager.shared.auth.currentUser!.email!) { (responseString, error) in
//            if let error = error {
//                print("Error: \(error.localizedDescription)")
//            } else if let responseString = responseString {
//                // handle response string here
//
//                var parse = responseString.trimmingCharacters(in: CharacterSet(charactersIn: "[\"\"]"))
//
//                parse = parse.replacingOccurrences(of: "\"", with: "")
//
//                var matches2 = parse.components(separatedBy: ",")
//                //print("Before: " + matches2.joined(separator: ","))
//                matches2.append("trudogmill@gmail.com")
//                matches2.append("tmillican6362@gmail.com")
//                matches2.append("truittamillican@gmail.com")
//                //print("After: " + matches2.joined(separator: ","))
//                for email3 in matches2{
//                    //print("email2: " + email3)
//                    self.getData(userEmail: email3) { (responseString2, error) in
//                        if let responseString2 = responseString2{
//                            //print("Data: " + email3 + "  " + responseString2)
//                            if responseString2.count > 10{
//                                if let data = responseString2.data(using: .utf8) {
//                                    do {
//                                        let json = try JSONSerialization.jsonObject(with: data, options: [])
//                                        if let dictionary = json as? [String: Any] {
//                                            print("okay")
//                                            print(dictionary)
//                                        }
//                                    } catch {
//                                        print(error.localizedDescription)
//                                    }
//                                }
//                            }
//                        }
//                    }
//
//                }
//            }
//        }
//
            
        }
//    func getData(userEmail: String, completionHandler: @escaping (String?, Error?) -> Void) {
//        if let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/InefficientMessage/\(userEmail)"){
//            print("url: " + url.absoluteString)
//            let session = URLSession.shared
//
//            let task = session.dataTask(with: url) { (data, response, error) in
//                if let error = error {
//                    completionHandler(nil, error)
//                } else if let data = data {
//                    let responseString2 = String(data: data, encoding: .utf8)
//                    completionHandler(responseString2, nil)
//                } else {
//                    completionHandler(nil, nil)
//                }
//            }
//            task.resume()
//        }
//
//    }
//
//    func getMatches(userEmail: String, completionHandler: @escaping (String?, Error?) -> Void) {
//        let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Match/\(userEmail)")!
//        let session = URLSession.shared
//
//        let task = session.dataTask(with: url) { (data, response, error) in
//            if let error = error {
//                completionHandler(nil, error)
//            } else if let data = data {
//                let responseString = String(data: data, encoding: .utf8)
//                completionHandler(responseString, nil)
//            } else {
//                completionHandler(nil, nil)
//            }
//        }
//        task.resume()
//    }
    
    /**
     List of recent messaegs to display
     */
    @Published var recentMessages = [RecentMessage]()
    
    private var firestoreListener: ListenerRegistration?
    /**
        Gets the name of the user
     - Parameters:
     - email: email to which the API call is mage
     */
    func getUsername(email: String, completion:@escaping ([User]) -> ()) {
        guard let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Owner/\(email),%201") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let owners = try! JSONDecoder().decode([User].self, from: data!)
            print(owners)
            
            DispatchQueue.main.async {
                completion(owners)
            }
        }
        .resume()
    }
    
    
    /**
     Gets all of the recent messages that need to be displayed and adds them to the above class list
     */
    func fetchRecentMessages() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        
        firestoreListener?.remove()
        self.recentMessages.removeAll()
        
        firestoreListener = FirebaseManager.shared.firestore
            .collection(FirebaseConstants.recentMessages)
            .document(uid)
            .collection(FirebaseConstants.messages)
            .order(by: FirebaseConstants.timestamp)
            .addSnapshotListener { querySnapshot, error in
                if let error = error {
                    self.errorMessage = "Failed to listen for recent messages: \(error)"
                    print(error)
                    return
                }
                
                querySnapshot?.documentChanges.forEach({ change in
                    let docId = change.document.documentID
                    
                    if let index = self.recentMessages.firstIndex(where: { rm in
                        return rm.id == docId
                    }) {
                        self.recentMessages.remove(at: index)
                    }
                    
                    do {
                        if let rm = try change.document.data(as: RecentMessage?.self) {
                            self.recentMessages.insert(rm, at: 0)
                        }
                    } catch {
                        print(error)
                    }
                })
            }
    }
    
    
    /**
     fetches the info of the current user in the firebase db
     */
    func fetchCurrentUser() {
        print("inside")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else {
            print("Could not find firebase uid")
            return
        }
        
        FirebaseManager.shared.firestore.collection("users").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fetch current user:", error)
                return
            }
            
            self.chatUser = try? snapshot?.data(as: ChatUser.self)
            FirebaseManager.shared.currentUser = self.chatUser
            print("Fetched Current User")
            //print(FirebaseManager.shared.currentUser?.email)
        }
        
    }
    
}
/**
 Actual display in the app. A View
 */
    struct messagesTemp: View {
        /**
         used to hold the user's information as when the inefficientmessage api is called
         */
        @State var results = [info]()
        /**
                used to keep track of which screen to display: messages or new messages
         */
        @State var shouldNavigateToChatLogView = false
        /**
                used to keep all of the user's information observable throughout the chat space
         */
        @ObservedObject public var vm = MainMessagesViewModel()
        /**
                chatLogViewModel used as a model for how the chat log should be displayed
         */
        private var chatLogViewModel = ChatLogViewModel(chatUser: nil)
        /**
         acutal body of what is displayed on screen
         */
        var body: some View {
            NavigationView {
                
                VStack {
                    customNavBar
                    messagesView
                    
                    NavigationLink("", isActive: $shouldNavigateToChatLogView) {
                        ChatLogView(vm: chatLogViewModel)
                    }
                    
                }
                .overlay(
                    newMessageButton, alignment: .bottom)
                .navigationBarHidden(true)
                .onAppear{self.loadData(email: vm.chatUser?.email ?? "")}
            }
        }
        /**
         Displays the user's name/dog at the top along with their online status
         */
        private var customNavBar: some View {
            HStack(spacing: 16) {
                
                VStack(alignment: .leading, spacing: 4) {
                    let email = vm.chatUser?.email.replacingOccurrences(of: "@gmail.com", with: "") ?? ""
                    ForEach(results, id: \.id) { item in
                                                    VStack(alignment: .leading) {
                                                        Text(item.Item3 + "/" + item.Item2).font(.system(size: 24, weight: .bold))
                                                    }
                                                }
                    
                    HStack {
                        Circle()
                            .foregroundColor(.green)
                            .frame(width: 14, height: 14)
                        Text("online")
                            .font(.system(size: 12))
                            .foregroundColor(Color(.lightGray))
                    }
                    
                }
                
                Spacer()
                
            }
            .padding()
            
            
        }
        /**
         Actual view for the messages
         */
        private var messagesView: some View {
            ScrollView {
                ForEach(vm.recentMessages) { recentMessage in
                    VStack {
                        Button {
                            let uid = FirebaseManager.shared.auth.currentUser?.uid == recentMessage.fromId ? recentMessage.toId : recentMessage.fromId
                            
                            self.chatUser = .init(id: uid, uid: uid, email: recentMessage.email)
                            
                            self.chatLogViewModel.chatUser = self.chatUser
                            self.chatLogViewModel.fetchMessages()
                            self.shouldNavigateToChatLogView.toggle()
                        } label: {
                            HStack(spacing: 16) {
                    
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(recentMessage.username)
                                        .font(.system(size: 16, weight: .bold))
                                        .foregroundColor(Color(.label))
                                        .multilineTextAlignment(.leading)
                                    Text(recentMessage.text)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(.darkGray))
                                        .multilineTextAlignment(.leading)
                                }
                                Spacer()
                                
                                Text(recentMessage.timeAgo)
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color(.label))
                            }
                        }


                        
                        Divider()
                            .padding(.vertical, 8)
                    }.padding(.horizontal)
                    
                }.padding(.bottom, 50)
            }
        }
        /**
                    Used to keep track of if the new message screen should be displayed. Toggled by the newmessage button
         */
        @State var shouldShowNewMessageScreen = false
        /**
                button that takes the user to the newMessages view
         */
        private var newMessageButton: some View {
            Button {
                shouldShowNewMessageScreen.toggle()
            } label: {
                HStack {
                    Spacer()
                    Text("+ New Message")
                        .font(.system(size: 16, weight: .bold))
                    Spacer()
                }
                .foregroundColor(.white)
                .padding(.vertical)
                    .background(Color.blue)
                    .cornerRadius(32)
                    .padding(.horizontal)
                    .shadow(radius: 15)
            }
            .fullScreenCover(isPresented: $shouldShowNewMessageScreen) {
                CreateNewMessageView(didSelectNewUser: { user in
                    print(user.email)
                    self.shouldNavigateToChatLogView.toggle()
                    self.chatUser = user
                    self.chatLogViewModel.chatUser = user
                    self.chatLogViewModel.fetchMessages()
                })
            }
        }
        /**
            A Chatuser used to keep track of the info of the current signin user for chatting
         */
        @State var chatUser: ChatUser?
        
        func loadData(email: String) {
                    //let email = vm.chatUser?.email ?? ""
                    print("email: " + email)
                        guard let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/InefficientMessage/\(email)") else {
                            print("Your API end point is Invalid")
                            return
                        }
                        let request = URLRequest(url: url)

                        URLSession.shared.dataTask(with: request) { data, response, error in
                            if let data = data {
                                if let response = try? JSONDecoder().decode([info].self, from: data) {
                                    DispatchQueue.main.async {
                                        self.results = response
                                        print("Data:!")
                                        print(response)
                                    }
                                    return
                                }
                            }
                            print("Rsp!")
                            print(data)
                        }.resume()
                    }
        
    }
    /**
     The preview provider for messagesTemp SImply takes the user to messagesTemp
     */
    struct messagesTemp_Previews: PreviewProvider {
        static var previews: some View {
            messagesTemp()
        }
    }

