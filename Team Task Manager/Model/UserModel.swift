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
}

struct MailModel: Codable {
    
    var title: String?
    var email: String?
    
}

struct PhoneNumberModel: Codable {
    var title: String?
    var phoneNumber: String?
}
