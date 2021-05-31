//
//  ChatModel.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 29.05.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MessageModel: Codable, Identifiable {
    @DocumentID var id: String?
    var teamID: String
    var userID: String?
    var date: Timestamp
    var message: String
}
