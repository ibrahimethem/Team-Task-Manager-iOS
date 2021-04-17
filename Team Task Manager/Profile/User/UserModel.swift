//
//  UserModel.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 23.03.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userID: String!
    var profileName: String!
    var email: String!
    var otherEmails: [String]?
    var bio: String?
    var phoneNumbers: [String]?
    
    enum codingKeys: String, CodingKey {
        case userID
        case profileName
        case email
        case otherEmails
        case bio
        case phoneNumbers
    }
    
    var dict: [String:Any] {
        var temp: [String: Any] = ["userID": userID!, "profileName": profileName!, "email": email!]
        if otherEmails != nil { temp["otherEmails"] = otherEmails! }
        if bio != nil { temp["bio"] = bio! }
        if phoneNumbers != nil { temp["phoneNumbers"] = phoneNumbers! }
        
        return temp
    }
    
    func asDictionary() -> [String: Any] {
        var dic = ["userID": userID ?? "","profileName": profileName ?? "", "email": email ?? ""]
        if bio != nil { dic["bio"] = bio! }
        
        return dic
    }
}
