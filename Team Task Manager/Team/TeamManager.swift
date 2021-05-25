//
//  TeamManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 13.05.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

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
    var invitedMembersDelegate: InvitedMembersDelegate?
    
    var team: TeamModel?
    var users: [UserModel]?
    
    func addSnapshotListener() {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        
        db.collection("TeamsTasks").document(teamID).addSnapshotListener { [unowned self] documentSnapshot, error in
            if let err = error {
                print(err)
            }
            
            if let team = try? documentSnapshot?.data(as: TeamModel.self) {
                self.team = team
                self.delegate.didLoadTeam(self, team: team)
            }
        }
    }
    
    func updateOverview(name: String, description: String) {
        team?.teamName = name
        team?.teamDescription = description
        updateTeam()
    }
    
    func userDidLoadTeam(userID: String) {
        if let i = team?.membersInfo.firstIndex(where: { $0.userID ==  userID}) {
            team?.membersInfo[i].joinDate = Timestamp()
        } else {
            let memberInfo = MemberInfo(userID: userID, joinDate: Timestamp())
            team?.membersInfo.append(memberInfo)
        }
        updateTeam()
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
                self.delegate.didLoadMembers(self, members: self.users!)
            }
        }
    }
    
    func getInvitedMembers() {
        guard let memberArray = team?.invitedMembers, memberArray.count > 0 else { return }
        db.collection("userProfileInfo").whereField("userID", in: memberArray).getDocuments { querySnapshot, error in
            if let err = error {
                print(err)
            }
            if let documents = querySnapshot?.documents {
                let userArray = documents.compactMap({ queryDocumentSnapshot -> UserModel? in
                    return try? queryDocumentSnapshot.data(as: UserModel.self)
                })
                self.invitedMembersDelegate?.didLoadInvitedMembers(self, invitedMembers: userArray)
            }
        }
    }
    
    func kickMember(with id: String) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        if team?.adminID == userID {
            if let i = team?.members.firstIndex(where: {$0 == id}) {
                team?.members.remove(at: i)
                updateTeam()
            }
            
        } else {
            print("You are not admin")
        }
    }
    
    func inviteMember(with email: String) {
        db.collection("userProfileInfo").whereField("email", isEqualTo: email).getDocuments { QuerySnapshot, error in
            if error != nil {
                print(error!)
                return
            }
            
            if let doc = QuerySnapshot?.documents.first {
                if let userID = try? doc.data(as: UserModel.self)?.id {
                    if (self.team?.invitedMembers?.contains(userID) ?? true) {
                        print("User already invited")
                    } else if (self.team?.members.contains(userID) ?? true) {
                        print("User is already a member")
                    } else {
                        self.team?.invitedMembers?.append(userID)
                        self.updateTeam()
                    }
                }
            } else {
                print("There is no such user.")
            }
            
        }
    }
    
    func updateTeam() {
        guard let teamID = delegate.teamID else {
            print("You need to set delegate first")
            return
        }
        do {
            try db.collection("TeamsTasks").document(teamID).setData(from: team)
        } catch {
            print(error)
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
            
            let presentedVC = UIStoryboard(name: "Team", bundle: nil).instantiateViewController(withIdentifier: "SectionDetailViewController") as! SectionDetailViewController
            
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
            
            let presentedVC = UIStoryboard(name: "Team", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailViewController") as! TaskDetailViewController
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
    func didLoadMembers(_ teamManager: TeamManager, members: [UserModel])
}

protocol InvitedMembersDelegate {
    func didLoadInvitedMembers(_ teamManager: TeamManager, invitedMembers: [UserModel])
}
