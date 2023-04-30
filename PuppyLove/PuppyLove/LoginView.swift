//
//  LoginView.swift
//  PuppyLove
//
//  Created by Aaron Sanchez on 3/15/23.
//

import SwiftUI
import GoogleSignInSwift
import GoogleSignIn
import Amplify

class UserAuthModel: ObservableObject {
    let signInConfig = GIDConfiguration.init(clientID: "CLIENT_ID")
    @Published var givenName: String = ""
    @Published var profilePicUrl: String = ""
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String = ""
    @Published var emailAddress: String = ""
    @Published var hasAccount: Bool = false
    @Published var ownerID: Int?
    // Adding in the dog variables and other owner variables that need to be displayed
    @Published var dogID: Int?
    @Published var dogName: String = ""
    @Published var dogBreed: String = ""
    @Published var dogAge: String = ""
    @Published var dogInfo: String = ""
    @Published var ownerAge: Int?
    @Published var ownerSex: String = ""
    @Published var userPhoto: Data? = nil
    @Published var profilePhoto: Data? = nil
    
    
    func downloadDogImage() async throws {
        print("downloading image")
        let imageKey: String = "\(emailAddress)-Dog"
        let downloadTask = Amplify.Storage.downloadData(key: imageKey)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
        userPhoto = try await downloadTask.value
        print("Completed")
    }
    
    func downloadProfileImage() async throws {
        print("downloading image")
        let imageKey: String = "\(emailAddress)"
        let downloadTask = Amplify.Storage.downloadData(key: imageKey)
            Task {
                for await progress in await downloadTask.progress {
                    print("Progress: \(progress)")
                }
            }
        profilePhoto = try await downloadTask.value
        print("Completed")
    }
    
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
            if let email2 = GIDSignIn.sharedInstance.currentUser?.profile?.email{
                FirebaseManager.shared.auth.signIn(withEmail: email2, password: "P@ssw0rd!")
                print("Wowow: " + email2)
                FirebaseManager.shared.currentUser?.email = email2
            }
            
            checkAccount()
        }else{
            self.isLoggedIn = false
            self.givenName = "Not Logged In"
            self.profilePicUrl =  ""
        }
    }

    func checkAccount() {
        let email = self.emailAddress
        let emailCheck = "https://puppyloveapishmeegan.azurewebsites.net/Owner/" + email + ",%201"

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
                        self.ownerAge = json?["Age"] as? Int
                        self.ownerSex = json?["Sex"] as? String ?? ""
                        let givenName = json?["OwnerName"] as? String
                        self.hasAccount = true
                        // Store the ownerID in the @Published variable
                        self.ownerID = json?["OwnerID"] as? Int
                        self.grabDogVariables()
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
    
    func grabDogVariables()
    {
        // Start to populate other global variables that will be used for the profile
        let dogCheck = "https://puppyloveapishmeegan.azurewebsites.net/Email/" + self.emailAddress
        if let dogUrl = URL(string: dogCheck) {
            let dogTask = URLSession.shared.dataTask(with: dogUrl) { data, response, error in
                guard let dogData = data, error == nil else {
                    print("Error: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }

                do {
                    // something wrong with this atm
                    DispatchQueue.main.async{
                        do {
                            let dogJson = try JSONSerialization.jsonObject(with: dogData, options: []) as? [String: Any]
                            self.dogName = dogJson?["DogName"] as? String ?? ""
                            self.dogAge = dogJson?["Age"] as? String ?? ""
                            self.dogBreed = dogJson?["Breed"] as? String ?? ""
                            self.dogInfo = dogJson?["AdditionalInfo"] as? String ?? ""
                            self.dogID = dogJson?["DogID"] as? Int ?? 0
                        }
                        catch {
                            print("Error: \(error.localizedDescription)")
                        }
                    }

                }
                catch let error {
                    print("Error decoding JSON: \(error.localizedDescription)")
                }
            }
            dogTask.resume()
        }
        
        Task {
            do
            {
                try await self.downloadDogImage()
            } catch {
                print("Error initializing ProfileText: \(error)")
            }
        }
        
        Task {
            do
            {
                try await self.downloadProfileImage()
            } catch {
                print("Error initializing ProfileText: \(error)")
            }
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
         try? FirebaseManager.shared.auth.signOut()
         self.checkStatus()
         Card.data = []
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
        guard let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Owner/") else { return }
        
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
        let eligbleDogs = "https://puppyloveapishmeegan.azurewebsites.net/SwipeList/" + emailAddress
        guard let url = URL(string: eligbleDogs) else { return }
        
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
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color(red: 0.784, green: 0.635, blue: 0.784))
            .onAppear {
                DispatchQueue.global(qos: .background).async {
                    while vm.emailAddress.isEmpty {
                        print("User not logged in yet")
                        sleep(2)
                    }
                    print("User logged in with email: \(vm.emailAddress)")
                    vm.getDogComments { dogs in
                        self.dogs = dogs
                for dog in dogs {
                let newCard = Card(name: dog.DogName, imageName: "p0", age: dog.Age, bio: dog.AdditionalInfo, dogID: dog.DogID)
                if !Card.data.contains(where: { $0.dogID == newCard.dogID}) {
                    Card.data.append(newCard)
                } else {
                    print("Did not meet compatibility score")
                }
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
