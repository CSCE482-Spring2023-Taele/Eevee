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
            print("dogs")
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
    
    fileprivate func SignInButton() -> Button<Text> {
        Button(action: {
            vm.handleSignInButton()
        }) {
            Text("Sign In")
        }
    }
    
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
            }
            .onAppear {
                vm.getDogComments { dogs in
                    self.dogs = dogs
                    var urlString: String?
                    var receivedValue: Double?

                    for dog in dogs {
                        let ownerUrl = "https://puppyloveapi.azurewebsites.net/Owner/"+String(dog.OwnerID)
                        guard let url = URL(string: ownerUrl) else {
                            print("Invalid URL")
                            return
                        }
                        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                            guard let data = data, error == nil,
                                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                                  let ownerEmail = json["ownerEmail"] as? String else {
                                print("Invalid response")
                                return
                            }
                            let urlString = "https://puppylovema.azurewebsites.net/api/puppylove?userEmail=" + vm.emailAddress+"&matchEmail="+ownerEmail
                            
                     //       print(urlString)
                            
                            if let url = URL(string: urlString) {
                                let task = URLSession.shared.dataTask(with: url) { data, response, error in
                                    guard let data = data, error == nil,
                                          let responseString = String(data: data, encoding: .utf8) else {
                                        print("Invalid response")
                                        return
                                    }
                                    
                                    // Use the string value here
                                    print("\(responseString)")
                                }
                                
                                task.resume()
                            } else {
                                print("Invalid URL")
                            }

//                            if let url = URL(string: urlString) {
//                                let task = URLSession.shared.dataTask(with: url) { data, response, error in
//                                    guard let data = data, error == nil,
//                                          let responseJSON = try? JSONSerialization.jsonObject(with: data, options: []),
//                                          let value = responseJSON as? Double else {
//                                        print("Invalid response")
//                                        return
//                                    }
//                                    receivedValue = value
//
//                                    // Use the double value here
//                                    print("The value is: \(value)")
//                                }
//
//                                task.resume()
//                            } else {
//                                print("Invalid URL")
//                            }
                        }
                        task.resume()

                        let newCard = Card(name: dog.DogName, imageName: "p0", age: dog.Age, bio: dog.AdditionalInfo, dogID: dog.DogID)
                            if !Card.data.contains(where: { $0.dogID == newCard.dogID}) {
                                Card.data.append(newCard)
                            }
                    }
                }
            }

            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.784, green: 0.635, blue: 0.784))
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
