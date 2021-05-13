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
    var otherEmails: [MailModel]?
    var bio: String?
    var phoneNumbers: [PhoneNumberModel]?
    
    enum codingKeys: String, CodingKey {
        case userID
        case profileName
        case email
        case otherEmails
        case bio
        case phoneNumbers
    }
    
//    var dict: [String:Any] {
//        var temp: [String: Any] = ["userID": userID!, "profileName": profileName!, "email": email!]
//        if otherEmails != nil { temp["otherEmails"] = otherMailsAsArray }
//        if bio != nil { temp["bio"] = bio! }
//        if phoneNumbers != nil { temp["phoneNumbers"] = phoneNumbersAsArray
//
//        }
//
//        return temp
//    }
//
//    func asDictionary() -> [String: Any] {
//        var dic = ["userID": userID ?? "","profileName": profileName ?? "", "email": email ?? ""]
//        if bio != nil { dic["bio"] = bio! }
//
//        return dic
//    }
//
//    private var otherMailsAsArray: [[String:Any]] {
//        var temp: [[String:Any]] = []
//        for mail in otherEmails ?? [] {
//            temp.append(mail.dict)
//        }
//        return temp
//    }
//
//    private var phoneNumbersAsArray: [[String:Any]] {
//        var temp: [[String:Any]] = []
//        for number in phoneNumbers ?? [] {
//            temp.append(number.dict)
//        }
//
//        return temp
//    }
    
}

struct MailModel: Codable {
    
    var title: String?
    var email: String?
    
//    var dict: [String: Any] {
//        return ["title": title ?? "Other", "email": email ?? "Other"]
//    }
}

struct PhoneNumberModel: Codable {
    
    var title: String?
    var phoneNumber: String?
    
//    var dict: [String: Any] {
//        return ["title": title ?? "Other", "phoneNumber": phoneNumber ?? "Other"]
//    }
}
