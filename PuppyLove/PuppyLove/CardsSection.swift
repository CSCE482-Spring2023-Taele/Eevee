import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Firebase

/**
 Class containing the user's information
 Contains the users email, anem, and if the account with that email is created or not
 */
class Email{
    var email: String
    var created: String
    var name: String
    /**
     Init of the class
     - PArameters
     -email: email of the user
    -name: name of the user
     */
    init(email: String, name:String) {
        self.email = email
        self.created = "0"
        self.name = name
    }
}
/**
 creates the inital email opbject and finds the user's email
 */
struct CardsSection: View {
    //let didCompleteLoginView: () -> ()
    @State var email = Email(email: "", name:"")
    private func setEmail() ->String{
        if let email2 = GIDSignIn.sharedInstance.currentUser?.profile?.email{
            return email2
            
        }
        return ""
    }
    /**
     init to be run when first appears on screen
        It sets the users email to what was found in setEmail
        It will then either login the user if an account is found in the DB or create a new account if not
     */
    init(){
        print(setEmail())
        self.email.email = setEmail()
        print(email.email)
        loginUser()
        print("Login: " + self.email.created)
        if self.email.created == "0"{
            createNewAccount()
        }
        
        
    }/**
      Callses messagesTemp to display all of the relevant messages
      */
    var body: some View {
        
//        VStack{
//            Text(self.email.created)
//        }
        messagesTemp()
        
        
    }
    /**
     signs the users out of messages
     */
    func handleSignOut() {
        
        try? FirebaseManager.shared.auth.signOut()
    }
    /**
     logs the user into firebase
     */
    private func loginUser() {
        print("here")
        FirebaseManager.shared.auth.signIn(withEmail: email.email, password: "P@ssw0rd!") { result, err in
            if let err = err {
                print("Failed to login user:", err)
                self.email.created = "0"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            self.email.created = "1"
            //self.didCompleteLoginView()
            //storeUserInformation()
            
          
        }
    }
    /**
     creates a new account if the user is not found in the firebase db
     */
    private func createNewAccount() {
        
        
        FirebaseManager.shared.auth.createUser(withEmail: email.email, password: "P@ssw0rd!") { result, err in
            if let err = err {
                print("Failed to create user:", err)
                
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            self.email.created = "1"
            storeUserInformation()
            
            
            
        }
    }
    /**
     stores the user's email and uid in the firebase db
     */
    private func storeUserInformation() {
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.email: self.email.email, FirebaseConstants.uid: uid] as [String:Any]
        FirebaseManager.shared.firestore.collection(FirebaseConstants.users)
            .document(uid).setData(userData) { err in
                if let err = err {
                    print(err)
                    //self.loginStatusMessage = "\(err)"
                    return
                }
                
                print("Success")
                //self.didCompleteLoginView()
                //self.didCompleteLoginProcess()
            }
    }
}
/**
 serves as the preview of the page to be displayed
 */
struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection()
    }
}
