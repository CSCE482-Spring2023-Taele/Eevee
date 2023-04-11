//
//  Matches.swift
//  PuppyLove
//
//  Created by Truitt Millican on 4/9/23.
//

import Foundation

//struct matchEmail: Codable{
//    var name: String
//}

@MainActor class MatchAPI : ObservableObject {
    class func getMatches(userEmail: String, completion: @escaping (String) -> ()) {
        let url = URL(string: "https:/puppyloveapi.azurewebsites.net/Match/\(userEmail)")!
        
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error!)
                completion("")
            } else {
                if let returnData = String(data: data!, encoding: .utf8) {
                    completion(returnData)
                } else {
                    completion("")
                }
            }
        }
        .resume()
            
    }
}

