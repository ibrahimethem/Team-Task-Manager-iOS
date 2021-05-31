//
//  UserLogManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 29.05.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class UserLogManager {
    
    static var shared = UserLogManager()
    var userLog: UserLogModel?
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    func addSnapshotListener() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("UserLogs").whereField("userID", isEqualTo: userID).addSnapshotListener { querySnapshot, error in
            if let err = error as NSError? {
                print(err)
            }
            
            if let document = querySnapshot?.documents.first {
                if let log = try? document.data(as: UserLogModel.self) {
                    self.userLog = log
                }
            }
        }
    }
    
    func getUserLog(for teamID: String) -> TeamLogModel {
        if userLog != nil, let log = userLog!.teamLogs?.first(where: { $0.teamID == teamID }) {
            return log
        } else {
            let log = TeamLogModel(teamID: teamID, chatLastSeen: Timestamp(), teamLastSeen: Timestamp())
            let _ = try? db.collection("UserLogs").addDocument(from: log)
            return log
        }
    }
    
}
