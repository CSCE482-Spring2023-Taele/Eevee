import UIKit

struct Card: Identifiable, Codable {
    
    let id = UUID()
    let name: String
    let imageName: String
    let age: String
    let bio: String
    let dogID: Int
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
    
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
