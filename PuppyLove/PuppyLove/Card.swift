import UIKit

struct Card: Identifiable, Codable {
    /**
     This is a struct to define the card class which will store a variety of variables to display the profiles
     ## Important Notes ##
     1. This creates cards using information that is iterated through in the LoginView file to sort through each eligible dog
     
     - parameters:
        -a: id = the id of the current card object
        -b: name = the name of the dog
        -c: imagedata = the image data of the profile photo of the dog that will be later manipulated to a picture
        -d: age = age of the dog
        -e: bio = bio of the dog
        -f: dogID = dogID of the dog
        -g: x = the x value of the position of the card
        -h: y = the y value of the position of the card
        -i: degree = degree of the card being rotated
     
     - returns:
     a card that is displayable on the swipe page
     */
    let id = UUID()
    let name: String
    let imageData: Data // Store the image data instead of UIImage directly
    let age: String
    let bio: String
    let dogID: Int
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
/**
 This initializes the card object's variables with the information we need to construct a new card
 */
    init(name: String, imageData: Data, age: String, bio: String, dogID: Int) {
        self.name = name
        self.age = age
        self.bio = bio
        self.dogID = dogID
        self.imageData = imageData
    }
    /**
     This allows for the data to be retrieved to display the cards using a JSON decoder to decode the card objects from an array of card objects
     */
    static var data: [Card] {
           get {
               // Retrieve the data array from UserDefaults
               if let data = UserDefaults.standard.data(forKey: "cards"),
                  let cards = try? JSONDecoder().decode([Card].self, from: data) {
                   return cards
               } else {
                   return []
               }
           }
           set {
               // Store the data array in UserDefaults
               if let encodedData = try? JSONEncoder().encode(newValue) {
                   UserDefaults.standard.set(encodedData, forKey: "cards")
               }
           }
       }
}
