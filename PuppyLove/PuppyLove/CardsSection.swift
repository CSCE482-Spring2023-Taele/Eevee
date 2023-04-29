import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Firebase


public var eemail = ""
public var ecreated = ""
public var ename = ""
public var edog = ""
    


struct CardsSection: View {
    //let didCompleteLoginView: () -> ()
    @State var results = [info]()
    //@State var email = Email(email: "", name:"")
    private func setEmail() ->String{
        if let email2 = GIDSignIn.sharedInstance.currentUser?.profile?.email{
            return email2

        }
        return ""
    }
    
    init(){
        //print(setEmail())
        eemail = setEmail()
        print(eemail)
        loginUser()
        print("Login: " + ecreated)
        if ecreated == "0"{
            createNewAccount()
        }
        loadData()
        print("yayayay")
        for thing in results{
            print("WOw")
            print(thing)
        }
        
        
        
    }
    var body: some View {
        
//        VStack{
//            Text(self.email.created)
//        }
        messagesTemp()
        
        
    }
    
    func handleSignOut() {
        
        try? FirebaseManager.shared.auth.signOut()
    }
    
    private func loginUser() {
        print("here")
        FirebaseManager.shared.auth.signIn(withEmail: eemail, password: "P@ssw0rd!") { result, err in
            if let err = err {
                print("Failed to login user:", err)
                ecreated = "0"
                return
            }
            
            print("Successfully logged in as user: \(result?.user.uid ?? "")")
            
            ecreated = "1"
            //self.didCompleteLoginView()
            storeUserInformation()
            
          
        }
    }
    private func createNewAccount() {
        
        
        FirebaseManager.shared.auth.createUser(withEmail: eemail, password: "P@ssw0rd!") { result, err in
            if let err = err {
                print("Failed to create user:", err)
                
                return
            }
            
            print("Successfully created user: \(result?.user.uid ?? "")")
            ecreated = "1"
            storeUserInformation()
            
            
            
        }
    }
    private func storeUserInformation() {
        @State var results = [info]()
        
        loadData()
        print("please")
        print(ename)
        print(edog)
        print("wowq")
        guard let uid = FirebaseManager.shared.auth.currentUser?.uid else { return }
        let userData = [FirebaseConstants.email: eemail, FirebaseConstants.uid: uid, FirebaseConstants.fromName: ename, FirebaseConstants.fromDog: edog] as [String:Any]
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
    func loadData() {
        let email = eemail
        print("emailhere: " + email)
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
                            print("Data22:!")
                            print(response)
                            ename = response[0].Item3
                            edog = response[0].Item2
                        }
                        return
                    }
                }
                print("Rsp!")
            }.resume()
        }
}

struct CardsSection_Previews: PreviewProvider {
    static var previews: some View {
        CardsSection()
    }
}
