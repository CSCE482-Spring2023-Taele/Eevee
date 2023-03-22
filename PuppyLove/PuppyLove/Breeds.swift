//
//  Breeds.swift
//  PuppyLove
//
//  Created by aaron on 3/22/23.
//

import Foundation

struct Breed: Codable, Identifiable {
    var id: Int
    var name: String
}

class DogAPI : ObservableObject {
    @Published var breeds = [Breed]()
    
    func loadData(completion:@escaping ([Breed]) -> ()) {
        guard let url = URL(string: "https://api.thedogapi.com/v1/breeds?limit=10&page=0") else {
            print("Invalid url...")
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            let breeds = try! JSONDecoder().decode([Breed].self, from: data!)
            print(breeds)
            DispatchQueue.main.async {
                completion(breeds)
            }
        }.resume()
    }
}
