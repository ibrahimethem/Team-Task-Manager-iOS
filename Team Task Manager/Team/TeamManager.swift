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
    var users: [UserModel]?
    
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
    
    func getMemebers(members: [String]?) {
        guard let memberArray = members else { return }
        db.collection("userProfileInfo").whereField("userID", in: memberArray).getDocuments { querySnapshot, error in
            if let err = error {
                print(err)
            }
            
            if let documents = querySnapshot?.documents {
                let userArray = documents.compactMap({ queryDocumentSnapshot -> UserModel? in
                    return try? queryDocumentSnapshot.data(as: UserModel.self)
                })
                self.users = userArray
            }
        }
        
    }
    
    func removeTask(sectionIndex: IndexPath, taskIndex: IndexPath) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            team?.sections[sectionIndex.item].tasks?.remove(at: taskIndex.row)
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
        }
    }
    
    func updateTask(sectionIndex: IndexPath, taskIndex: IndexPath, task: TaskModel) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            team?.sections[sectionIndex.item].tasks?[taskIndex.row] = task
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
        }
    }
    
    func removeSection(sectionIndex: IndexPath) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            team?.sections.remove(at: sectionIndex.item)
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
        }
    }
    
    func updateSection(sectionIndex: IndexPath, section: SectionModel) {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            team?.sections[sectionIndex.item] = section
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
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
    
    func editSection(_ sectionView: SectionView, section: SectionModel) {
        if let vc = delegate as? TeamViewController {
            guard let indexPath = sectionView.sectionIndex else { return }
            
            let presentedVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SectionDetailViewController") as! SectionDetailViewController
            
            presentedVC.sectionModel = section
            presentedVC.sectionIndex = indexPath
            presentedVC.presentingVC = vc
            
            vc.present(presentedVC, animated: true, completion: nil)
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
    
    func selectTask(_ sectionView: SectionView, task: TaskModel, taskIndex: IndexPath) {
        if let vc = delegate as? TeamViewController {
            guard let indexPath = sectionView.sectionIndex else { return }
            
            let presentedVC = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
            presentedVC.taskIndex = taskIndex
            presentedVC.sectionIndex = indexPath
            presentedVC.taskModel = task
            presentedVC.presentingVC = vc
            
            vc.present(presentedVC, animated: true, completion: nil)
        }
    }
    
    
}

protocol TeamManagerDelegate {
    var teamID: String? { get set }
    func didLoadTeam(_ teamManager: TeamManager, team: TeamModel)
}
