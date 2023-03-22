import UIKit

struct Card: Identifiable {
    let id = UUID()
    let name: String
    let imageName: String
    let age: Int
    let bio: String
    /// Card x position
    var x: CGFloat = 0.0
    /// Card y position
    var y: CGFloat = 0.0
    /// Card rotation angle
    var degree: Double = 0.0
    
    static var data: [Card] {
        [
            Card(name: "Snowy", imageName: "p0", age: 5, bio: "I am a good boy!"),
            Card(name: "Cooper", imageName: "p1", age: 2, bio: "I love long walks and playing catch!"),
            Card(name: "Lola", imageName: "p2", age: 7, bio: "I have an attitude!"),
            Card(name: "Duke", imageName: "p3", age: 1, bio: "I don't bite! I promise!"),
            Card(name: "Bear", imageName: "p4", age: 2, bio: "Im a lazy dog!"),
            Card(name: "Bella", imageName: "p5", age: 12, bio: "I am old please be patient with me!"),
        ]
    }
    
}
