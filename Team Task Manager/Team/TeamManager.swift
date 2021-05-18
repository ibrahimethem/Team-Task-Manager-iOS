//
//  TeamManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 13.05.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class TeamManager: SectionViewDelegate {
   
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    init(delegate: TeamManagerDelegate) {
        self.delegate = delegate
    }
    
    var delegate: TeamManagerDelegate
    var team: TeamModel?
    
    func addSnapshotListener() {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        
        db.collection("TeamsTasks").document(teamID).addSnapshotListener { [unowned self] documentSnapshot, error in
            print("got team")
            if let err = error {
                print(err)
            }
            
            if let team = try? documentSnapshot?.data(as: TeamModel.self) {
                self.team = team
                self.delegate.didLoadTeam(self, team: team)
            }
        }
    }
    
    
    // MARK: - Section View Delegate
    // In the first if of the try catch you need to use more clear way to do it. you give the sectionIndex sum of the item and section
    
    func addNewSection(_ sectionView: SectionView, section: SectionModel) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            team?.sections.append(section)
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
        }
        
    }
    
    func addTask(_ sectionView: SectionView, task: TaskModel) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            if let indexPath = sectionView.sectionIndex {
                team?.sections[indexPath.item].tasks?.append(task)
            }
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
        }
    }
    
    func selectTask(_ sectionView: SectionView, task: TaskModel) {
        print(task.title ?? "", "selected")
    }
    
    
}

protocol TeamManagerDelegate {
    var teamID: String? { get set }
    func didLoadTeam(_ teamManager: TeamManager, team: TeamModel)
}
