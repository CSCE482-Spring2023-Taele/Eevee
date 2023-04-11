//
//  LoginView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/15/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn

class UserAuthModel: ObservableObject {
    let signInConfig = GIDConfiguration.init(clientID: "CLIENT_ID")
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var emailAddress: String = ""
    @Published var hasAccount: Bool = false
    
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
            checkAccount()
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }
    
    func checkAccount() {
        let email = self.emailAddress
        let emailCheck = "https://puppyloveapi.azurewebsites.net/Owner/" + email + ",%201"
        if let emailUrl = URL(string: emailCheck) {
            let task = URLSession.shared.dataTask(with: emailUrl) { data, response, error in
                guard let data = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print(json)
                    if let ownerID = json?["OwnerID"] as? Int, ownerID == -1, let ownerEmail = json?["OwnerEmail"] as? String, ownerEmail.isEmpty == true {
                        self.hasAccount = false
                    } else {
                        print("Email Found")
                        self.hasAccount = true
                    }

                } catch let error {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            task.resume()
        } else {
            print("Invalid URL")
        }
        print(self.hasAccount)
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
    func getUserComments(completion:@escaping ([User]) -> ()) {
        guard let url = URL(string: "https://puppyloveapi.azurewebsites.net/Owner/") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let owners = try! JSONDecoder().decode([User].self, from: data!)
            print("owners")
            print(owners)
            
            DispatchQueue.main.async {
                completion(owners)
            }
        }
        .resume()
    }
    func getDogComments(completion:@escaping ([Dog]) -> ()) {
        guard let url = URL(string: "https://puppyloveapi.azurewebsites.net/Dog/") else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, _) in
            let dogs = try! JSONDecoder().decode([Dog].self, from: data!)
            print("grabbed dogs")
            print(dogs)
            
            DispatchQueue.main.async {
                completion(dogs)
            }
        }
        .resume()
    }
}

struct LoginView: View {
    @EnvironmentObject var vm: UserAuthModel
    @State var owners = [User]()
    @State var dogs = [Dog]()
    @State var showSignUp = false

    var body: some View {
        NavigationView {
            VStack {
                Text("PuppyLove")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontDesign(.serif)
                    .fontWidth(.expanded)
                    .fontWeight(.heavy)
                    .offset(x: 0, y: -100)

                GoogleSignInButton(action: vm.handleSignInButton)
                    .padding(10)
                    .opacity(0.95)

                NavigationLink("Sign Up", destination: SignUpView())
                    .navigationBarBackButtonHidden(true)
                    .hidden()
            }
            .sheet(isPresented: $showSignUp) {
                        SignUpView()
                    }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.784, green: 0.635, blue: 0.784))
            .onAppear {
                DispatchQueue.global(qos: .background).async {
                    while vm.emailAddress.isEmpty {
                        print("User not logged in yet")
                        sleep(2)
                    }
                    
//                    let email = vm.emailAddress
//                    let emailCheck = "https://puppyloveapi.azurewebsites.net/Owner/" + email + ",%201"
//                    if let emailUrl = URL(string: emailCheck) {
//                        let task = URLSession.shared.dataTask(with: emailUrl) { data, response, error in
//                            guard let data = data, error == nil else {
//                                print("Error: \(error?.localizedDescription ?? "Unknown error")")
//                                return
//                            }
//
//                            do {
//                                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
//                                if let ownerID = json?["ownerID"] as? Int, ownerID == -1 {
//                                    self.showSignUp = true
//                    //                self.showSignUpView()
//                                } else {
//                                    print("Email Found")
//                                    // Email found
//                                }
//                            } catch let error {
//                                print("Error decoding JSON: \(error.localizedDescription)")
//                            }
//                        }
//                        task.resume()
//                    } else {
//                        print("Invalid URL")
//                    }

                    
                    print("User logged in with email: \(vm.emailAddress)")

                    vm.getDogComments { dogs in
                        self.dogs = dogs

                        for dog in dogs {
                            let ownerUrl = "https://puppyloveapi.azurewebsites.net/Owner/\(dog.OwnerID)"
                            guard let url = URL(string: ownerUrl) else {
                                print("Invalid URL")
                                return
                            }
                            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                guard let data = data, error == nil,
                                      let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                                      let ownerEmail = json["ownerEmail"] as? String else {
                                    print("Invalid response: \(ownerUrl)")
                                    return
                                }
                                let urlString = "https://puppylovema.azurewebsites.net/api/puppylove?userEmail=\(vm.emailAddress)&matchEmail=\(ownerEmail)"
                                if(ownerEmail != vm.emailAddress) {
                                    if let url = URL(string: urlString) {
                                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                            guard let data = data, error == nil,
                                                  let responseString = String(data: data, encoding: .utf8) else {
                                                print("Invalid response")
                                                return
                                            }

                                            if let receivedValue = Double(responseString) {
                                                let newCard = Card(name: dog.DogName, imageName: "p0", age: dog.Age, bio: dog.AdditionalInfo, dogID: dog.DogID)
                                                if !Card.data.contains(where: { $0.dogID == newCard.dogID}) && receivedValue > 60.0 {
                                                    Card.data.append(newCard)
                                                } else {
                                                    print("Did not meet compatibility score")
                                                }
                                            } else {
                                                print("Could not convert responseString to Double")
                                            }
                                        }
                                        task.resume()
                                    } else {
                                        print("Invalid URL")
                                    }
                                }
                            }
                            task.resume()
                        }
                    }
                }
            }
        }
    }
}




struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
