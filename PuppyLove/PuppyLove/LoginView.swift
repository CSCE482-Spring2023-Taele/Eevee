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
    
    /**
     This is a struct to define the UserAuthModel to store information of the current logged in owner
     ## Important Notes ##
     1. This creates a group of variables that can be used in functions needed in the app
     
     - parameters:
        -a: givenName is the given name of the logged in user
        -b: profilePicUrl is the url that is used to grab the profile picture
        -c: isLoggedIn is a variable to check if the user is successfully logged in
        -d: errorMessage allows for an errorMessage to be printed out to test
        -e: hasAccount checks to see if it is a valid google account
        -f: ownerID is the id of the current owner that is logged in grabbed from the database
        -g: dogID is the id of the current owner's dog that is logged in grabbed from the database
        -h: dogName is the name of the current owner's dog
        -i: dogBreed is the breed of the current owner's dog
        -j: dogAge is the age of the current owner's dog
        -k: dogInfo is the info of the current owner's dog
        -l: ownerAge is the age of the current owner
        -m: ownerSex is the sex of the current owner
        -n: userPhoto is the photo of the current owner
        -o: profilePhoto is the profile photo of the current owner
        -p: dogPhoto is the dog photo of the current owner's dog
        -q: dogs is an array that stores the list of eligible dogs
     
     - returns:
     a logged in user and all associated information stored in variables for future use
     
     */
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
    @Published var dogPhoto: Data? = nil
    @Published var dogs = [Dog]()
    
    /**
        Downloads the dog image to showcase the picture on the swipe page
     */
    
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
//        print("Completed")
    }
    
    /**
        Downloads profile image to show the picture of the owner
     */
    
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
//        print("Completed")
    }
    
    init(){
        check()
    }
    
    /**
        This checks the status of the logged in user to check if it is a valid user or not
     */
    
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
    
    /**
        This checks if the user is a valid user if it is then grabs the array of all eligible dogs that the user can match with, it also downloads the image
     of the dog to create in the card so that the user has a full swipe page of profiles
     */

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
                        
                        Task {
                            print("User logged in with email: \(self.emailAddress)")
                            do {
                                print("Starting the do")
                                let dogs = try await self.getDogComments()
                                self.dogs = dogs
                                for dog in dogs {
                                    let imageKey: String = "\(dog.Email)-Dog"
                                    let downloadTask = Amplify.Storage.downloadData(key: imageKey)
                                    print("downloading image 1")
                                    Task {
                                        for await progress in await downloadTask.progress {
                                            print("Progress 1: \(progress)")
                                        }
                                    }
                                    print("completed")
                                    self.dogPhoto = try await downloadTask.value
                                    print("Hello")
                                    print("Completed")
                                    let newCard = Card(name: dog.DogName, imageData: self.dogPhoto!, age: dog.Age, bio: dog.AdditionalInfo, dogID: dog.DogID)
                                    if !Card.data.contains(where: { $0.dogID == newCard.dogID}) {
                                        Card.data.append(newCard)
                                        print("added a card")
                                    } else {
                                        print("Did not meet compatibility score")
                                    }
                                }
                            } catch {
                                print("Error fetching dog comments: \(error)")
                            }
                        }
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
    
    /**
        This grabs all the variables associated with the logged in owner's dog so the values are initiliazed
     */
    
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
                    DispatchQueue.main.async {
                        do {
                            let dogJson = try JSONSerialization.jsonObject(with: dogData, options: []) as? [String: Any]
                            self.dogAge = dogJson?["Age"] as? String ?? ""
                            self.dogBreed = dogJson?["Breed"] as? String ?? ""
                            self.dogInfo = dogJson?["AdditionalInfo"] as? String ?? ""
                            self.dogID = dogJson?["DogID"] as? Int ?? 0
                            self.dogName = dogJson?["DogName"] as? String ?? ""
                        } catch {
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

    /**
     This restores the session to check if they are already signed in
     */
    func check(){
        GIDSignIn.sharedInstance.restorePreviousSignIn { user, error in
            if let error = error {
                self.errorMessage = "error: \(error.localizedDescription)"
            }
            
            self.checkStatus()
        }
    }
    
     /**
      This method signs out the user from their current logged in session
      */
     func signOut(){
         GIDSignIn.sharedInstance.signOut()
         try? FirebaseManager.shared.auth.signOut()
         self.checkStatus()
         Card.data = []
     }
    /**
     This method allows for the user to sign in with a new instance
     */
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
    /**
     This method grabs all owners from the api to see a list of all other owners
     */
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
    /**
     This method all eligible dogs to swipe on and stores them to be used in the swipe page
     */
    func getDogComments() async throws -> [Dog] {
        let eligbleDogs = "https://puppyloveapishmeegan.azurewebsites.net/SwipeList/" + emailAddress
        guard let url = URL(string: eligbleDogs) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let dogs = try JSONDecoder().decode([Dog].self, from: data)
        print("grabbed dogs")
        return dogs
    }

}

struct LoginView: View {
    
    /**
     This is a struct that creates a login page for the users to access the app with their google account
     ## Important Notes ##
     1. This shows the login page so the user can access the app
     
     - parameters:
        -a: UserAuthModel is the object vm that stores all the information from the logged in user
        -b: owners is the array of user objects that have each owner stored
        -c: dogs is the array of dog objects that have each dog stored
        -d: showSignUp is a variable that stores if the user has an account or not
     
     - returns:
     a login page that allows the user to access the app
     */
    
    @EnvironmentObject var vm: UserAuthModel
    @State var owners = [User]()
    @State var dogs = [Dog]()
    @State var showSignUp = false
//    @State var dogPhoto: Data? = nil

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
//                Task {
//                    while vm.emailAddress.isEmpty {
//                        print("User not logged in yet")
//                        await Task.sleep(2_000_000_000) // sleep for 2 seconds
//                    }
//                    print("User logged in with email: \(vm.emailAddress)")
//                    do {
//                        print("Starting the do")
//                        let dogs = try await vm.getDogComments()
//                        self.dogs = dogs
//                        for dog in dogs {
//                            let imageKey: String = "\(dog.Email)-Dog"
//                            let downloadTask = Amplify.Storage.downloadData(key: imageKey)
//                            print("downloading image 1")
//                            await Task {
//                                for await progress in await downloadTask.progress {
//                                    print("Progress 1: \(progress)")
//                                }
//                            }
//                            print("completed")
//                            dogPhoto = try await downloadTask.value
//                            print("Hello")
//                            print("Completed")
//                            let newCard = Card(name: dog.DogName, imageData: dogPhoto!, age: dog.Age, bio: dog.AdditionalInfo, dogID: dog.DogID)
//                            if !Card.data.contains(where: { $0.dogID == newCard.dogID}) {
//                                Card.data.append(newCard)
//                                print("added a card")
//                            } else {
//                                print("Did not meet compatibility score")
//                            }
//                        }
//                    } catch {
//                        print("Error fetching dog comments: \(error)")
//                    }
//                }
            }







            }
        }
    }




struct LoginView_Previews: PreviewProvider {
    /**
     This struct calls for login view to show up
     */
    static var previews: some View {
        LoginView()
    }
}
