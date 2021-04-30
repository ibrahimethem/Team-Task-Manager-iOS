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
    var sectios: [SectionModel]?
    
    var dict: [String:Any] {
        var temp: [String:Any] = ["adminID":adminID!, "members": members!, "membersInfo": membersInfoAsDict]
        if let v = teamID { temp["teamID"] = v }
        if let v = invitedMembers { temp["invitedMembers"] = v }
        if sectios != nil { temp["sections"] = sectionsAsDict }
        
        return temp
    }
    
    var membersInfoAsDict: [[String:Any]] {
        var temp = [[String:Any]]()
        for info in membersInfo {
            temp.append(info.dict)
        }
        return temp
    }
    
    var sectionsAsDict: [[String:Any]] {
        var temp = [[String:Any]]()
        for section in sectios ?? [] {
            temp.append(section.dict)
        }
        return temp
    }
    
}

struct SectionModel: Codable {
    var title: String!
    var tasks: [TaskModel]?
    
    var dict: [String:Any] {
        var temp: [String:Any] = ["title":title!]
        if tasks != nil { temp["tasks"] = tasksAsDict }
        return temp
    }
    
    var tasksAsDict: [[String:Any]] {
        var temp = [[String:Any]]()
        for task in tasks ?? [] {
            temp.append(task.dict)
        }
        return temp
    }
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
