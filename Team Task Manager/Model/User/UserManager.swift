//
//  UserManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 15.04.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseFirestoreSwift

class UserManager {
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    var userModel: UserModel?
    var userModelSnapshot: ListenerRegistration?
    
    var delegate: UserManagerDelegate?
    
    func setListener() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        
        userModelSnapshot = db.collection("userProfileInfo").whereField("userID", isEqualTo: userID).addSnapshotListener { (querySnapshot, error) in
            if let err = error {
                print(err)
                return
            }
            if let documentChanges = querySnapshot?.documentChanges {
                if let myUser = try! documentChanges[0].document.data(as: UserModel.self) {
                    self.userModel = myUser
                    print(self.userModel?.dict as Any)
                    DispatchQueue.main.async {
                        self.delegate?.didFetchUser(self, user: self.userModel!)
                    }
                }
            }
        }
    }
    
    // Update database
    func updateUser(user: UserModel) {
        guard user.userID != nil else { return }
        db.collection("userProfileInfo").document(user.userID!).setData(user.dict) { (err) in
            if err != nil {
                print(err?.localizedDescription ?? "can't print the error")
            }
        }
    }
    
}

protocol UserManagerDelegate {
    func didFetchUser(_ userManager: UserManager, user: UserModel)
}
