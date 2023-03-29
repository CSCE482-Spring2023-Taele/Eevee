//
//  LoginView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/15/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

func handleSignInButton() {
    // https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed This is a good resource to google oauth
    // It is outdated, but shows how to use view controller
    guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}

    GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
    { signInResult, error in 
      guard let result = signInResult else {
        // Inspect error
        return
      }
      // If sign in succeeded, display the app's main content View.
    }
}

struct Comments: Codable, Identifiable {
    let id = UUID()
    let OwnerName: String
    let OwnerEmail: String
    let InstagramKey: String
    let Age: Int
    let Sex: String
    let Location: String
}

class UserAuthModel: ObservableObject {
    let signInConfig = GIDConfiguration.init(clientID: "CLIENT_ID")
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var emailAddress: String = ""
    
    init(){
        check()
    }
    
    func checkStatus(){
        if(GIDSignIn.sharedInstance.currentUser != nil){
            let user = GIDSignIn.sharedInstance.currentUser
            guard let user = user else { return }
            let givenName = user.profile?.givenName
            let profilePicUrl = user.profile!.imageURL(withDimension: 100)!.absoluteString
            self.givenName = givenName ?? ""
            self.profilePicUrl = profilePicUrl
            self.isLoggedIn = true
            self.emailAddress = user.profile!.email
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
     
     func signOut(){
         GIDSignIn.sharedInstance.signOut()
         self.checkStatus()
     }
    
    func handleSignInButton() {
        // https://paulallies.medium.com/google-sign-in-swiftui-2909e01ea4ed This is a good resource to google oauth
        // It is outdated, but shows how to use view controller
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController)
        { signInResult, error in
          guard let result = signInResult else {
            // Inspect error
            return
          }
            self.checkStatus()
          // If sign in succeeded, display the app's main content View.
            
        }
    }
    func getUserComments(completion:@escaping ([Comments]) -> ()) {
        guard let url = URL(string: "https://puppyloveapi.azurewebsites.net/Owner/") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let comments = try! JSONDecoder().decode([Comments].self, from: data!)
            print(comments)
            
            DispatchQueue.main.async {
                completion(comments)
            }
        }
        .resume()
    }
}


struct LoginView: View {
    @EnvironmentObject var vm: UserAuthModel
    @State var comments = [Comments]()
    fileprivate func SignInButton() -> Button<Text> {
        Button(action: {
            vm.handleSignInButton()
        }) {
            Text("Sign In")
        }
    }
    var body: some View {
        NavigationView {
                   //3.
                   List(comments) { comment in
                       VStack(alignment: .leading) {
                           if(comment.OwnerName == "keegan") {
                               Text(comment.OwnerName)
                                   .font(.title)
                                   .fontWeight(.bold)
                               Text(comment.OwnerEmail)
                                   .font(.subheadline)
                                   .fontWeight(.bold)
                               Text(comment.InstagramKey)
                                   .font(.body)
                               Text(String(comment.Age))
                                   .font(.body)
                               Text(comment.Sex)
                                   .font(.body)
                               Text(comment.Location)
                                   .font(.body)
                           }
                       }
                       
                   }
                   //2.
                   .onAppear() {
                       vm.getUserComments { (comments) in
                           self.comments = comments
                       }
                   }.navigationTitle("Comments")
               }
//        VStack {
//            Text("PuppyLove")
//                .foregroundColor(.white)
//                .font(.largeTitle)
//                .fontDesign(.serif)
//                .fontWidth(.expanded)
//                .fontWeight(.heavy)
//                .offset(x: 0, y: -100)
//
//            GoogleSignInButton(action: vm.handleSignInButton)
//                .padding(10)
//                .opacity(0.95)
//            NavigationLink("Sign Up", destination: SignUpView()).navigationBarBackButtonHidden(true)
//
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.init(red: 0.784, green: 0.635, blue: 0.784))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
