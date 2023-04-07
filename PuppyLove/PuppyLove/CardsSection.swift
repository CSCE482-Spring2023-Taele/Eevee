import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Firebase

class Email{
    var email: String
    var created: String
    init(email: String) {
        self.email = email
        self.created = "0"
    }
}

struct CardsSection: View {
    //let didCompleteLoginView: () -> ()
    @State var email = Email(email: "")
    private func setEmail() ->String{
        if let email2 = GIDSignIn.sharedInstance.currentUser?.profile?.email{
            return email2
            
        }
        return ""
    }
    
    init(){
        print(setEmail())
        self.email.email = setEmail()
        print(email.email)
        loginUser()
        print("Login: " + self.email.created)
        if self.email.created == "0"{
            createNewAccount()
        }
        
        
    }
    var body: some View {
        
//        VStack{
//            Text(self.email.created)
//        }
        messagesTemp()
        
        
    }
    
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

struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection()
    }
}
