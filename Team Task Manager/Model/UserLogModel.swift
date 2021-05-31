//
//  UserLogModel.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 29.05.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserLogModel: Codable, Identifiable {
    @DocumentID var id: String?
    var userID: String
    var teamLogs: [TeamLogModel]?
}

struct TeamLogModel: Codable {
    var teamID: String
    var chatLastSeen: Timestamp?
    var teamLastSeen: Timestamp?
}
