//
//  Matches.swift
//  PuppyLove
//
///  Created by Truitt Millican on 4/9/23.
//

import Foundation

//struct matchEmail: Codable{
//    var name: String
//}
/**
 API used to get the user's matches
 */
@MainActor class MatchAPI : ObservableObject {
    /**
            Accepts a string and makes an API call to get the matches of that email
        - Parameters:
     -userEmail: string
     */
    class func getMatches(userEmail: String, completion: @escaping (String) -> ()) {
        let url = URL(string: "https://puppyloveapishmeegan.azurewebsites.net/Match/\(userEmail)")!
        
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

