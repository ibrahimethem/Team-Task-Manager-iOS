//
//  TeamModel.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 13.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TeamModel: Identifiable, Codable {
    @DocumentID var id: String?
    var teamID: String?
    var teamName: String!
    var adminID: String!
    var members: [String]!
    var invitedMembers: [String]?
    var membersInfo: [MemberInfo]!
    var tasks: [TaskModel]?
    
    
}

struct TaskModel: Codable {
    var creationDate: Timestamp!
    var details: String!
    var title: String!
    
    var dict: [String:Any] {
        [
            "creationDate": creationDate!,
            "details": details!,
            "title": title!
        ]
    }
}

struct MemberInfo: Codable {
    var userID: String!
    var joinDate: Timestamp!
    
    var dict: [String:Any] {
        [
            "userID": userID!,
            "joinDate": joinDate!
        ]
    }
}
