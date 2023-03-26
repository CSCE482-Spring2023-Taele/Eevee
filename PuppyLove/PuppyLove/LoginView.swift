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

class UserAuthModel: ObservableObject {
    let signInConfig = GIDConfiguration.init(clientID: "CLIENT_ID")
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    
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
}

struct LoginView: View {
    var body: some View {
        VStack {
            Text("PuppyLove")
                .foregroundColor(.white)
                .font(.largeTitle)
                .fontDesign(.serif)
                .fontWidth(.expanded)
                .fontWeight(.heavy)
                .offset(x: 0, y: -100)
            
            GoogleSignInButton(action: handleSignInButton)
                .padding(10)
                .opacity(0.95)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.init(red: 0.784, green: 0.635, blue: 0.784))
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
