//
//  TeamManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 20.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class HomeManager {
    
    var teams: [TeamModel]?
    
    var delegate: HomeManagerDelegate?
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    private func mapDocuments<T: Decodable>(querySnapshot: QuerySnapshot?) -> [T]? {
        if let documents = querySnapshot?.documents {
            return documents.compactMap { queryDocumentSnapshot -> T? in
                return try? queryDocumentSnapshot.data(as: T.self)
            }
        }
        return nil
    }
    
    func addSnapshotListener() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("TeamsTasks").whereField("members", arrayContains: uid).addSnapshotListener { [unowned self] (querySnapshot, error) in
            if let err = error {
                self.delegate?.didFailLoadTeams(self, with: err)
                return
            }
            if self.teams == nil { // if it is first query just load all dictionaries
                self.teams = self.mapDocuments(querySnapshot: querySnapshot)
                self.delegate?.didLoadTeams(self, teams: self.teams ?? [])
            } else {
                if let documentChanges = querySnapshot?.documentChanges {
                    for change in documentChanges {
                        guard let team = try! change.document.data(as: TeamModel.self) else {return}
                        switch change.type {
                        case .removed:
                            self.teams?.removeAll(where: { (teamModel) -> Bool in
                                teamModel.id == team.id
                            })
                            self.delegate?.didRemoveTeam(self, team: team)
                        case .added:
                            self.teams?.append(team)
                            self.delegate?.didAddTeam(self, team: team)
                        case .modified:
                            if let index = self.teams?.firstIndex(where: { (teamModel) -> Bool in
                                teamModel.id == team.id
                            }) {
                                self.teams![index] = team
                                self.delegate?.didModifyTeam(self, team: team)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

protocol HomeManagerDelegate {
    func didLoadTeams(_ teamManager: HomeManager, teams: [TeamModel])
    func didModifyTeam(_ teamManager: HomeManager, team: TeamModel)
    func didAddTeam(_ teamManager: HomeManager, team: TeamModel)
    func didRemoveTeam(_ teamManager: HomeManager, team: TeamModel)
    func didFailLoadTeams(_ teamManager: HomeManager, with error: Error)
}
