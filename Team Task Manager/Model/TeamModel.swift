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
    var teamName: String
    var teamDescription: String
    var adminID: String
    var members: [String]
    var invitedMembers: [String]?
    var membersInfo: [MemberInfo]
    var sections: [SectionModel]
}

struct SectionModel: Codable {
    var title: String!
    var tasks: [TaskModel]?
}

struct TaskModel: Codable {
    var creationDate: Timestamp!
    var creator: String!
    var details: String!
    var title: String!
    var comments: [CommentModel]?
}

struct CommentModel: Codable {
    var comment: String
    var userID: String
    var date: Timestamp
}

struct MemberInfo: Codable {
    var userID: String!
    var joinDate: Timestamp!
}
