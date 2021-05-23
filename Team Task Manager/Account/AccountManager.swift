//
//  AccountManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 24.05.2021.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

struct TeamOverViewModel: Codable, Identifiable {
    @DocumentID var id: String?
    var teamName: String
    var teamDescription: String
    var invitedMembers: [String]?
    var members: [String]
}

class AccountManager {
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    var user: UserModel?
    var teams: [TeamOverViewModel]?
    
    var delegate: AccountManagerDelegate?
    
    func addSnapshotListener() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        db.collection("TeamsTasks").whereField("invitedMembers", arrayContains: userID).addSnapshotListener { querySnapshot, error in
            if error != nil {
                print(error!.localizedDescription)
            }
            
            if let docs = querySnapshot?.documents {
                let teams = docs.compactMap { queryDocumentSnapshot -> TeamOverViewModel? in
                    return try? queryDocumentSnapshot.data(as: TeamOverViewModel.self)
                }
                self.teams = teams
                self.delegate?.didLoadInvites(self, teamOverViews: teams)
            }
            
        }
        
        
    }
    
    func acceptInvite(docID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard var team = teams?.first(where: {$0.id == docID}) else { return }
        team.members.append(userID)
        if let i = team.invitedMembers?.firstIndex(of: userID) {
            team.invitedMembers?.remove(at: i)
        }
        do {
            try db.collection("TeamsTasks").document(team.id!).setData(from: team, merge: true)
        } catch {
            print("This is error")
        }
    }
    
    func declineInvite(docID: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard var team = teams?.first(where: {$0.id == docID}) else { return }
        if let i = team.invitedMembers?.firstIndex(of: userID) {
            team.members.remove(at: i)
        }
        do {
            try db.collection("TeamsTasks").document(team.id!).setData(from: team, merge: true)
        } catch {
            print("This is error")
        }
    }
    
}

protocol AccountManagerDelegate {
    func didLoadInvites(_ accountManager: AccountManager, teamOverViews: [TeamOverViewModel])
}
