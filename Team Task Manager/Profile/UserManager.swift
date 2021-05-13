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
    
    static var shared = UserManager()
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        //settings.isPersistenceEnabled = false
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
                    DispatchQueue.main.async {
                        self.delegate?.didFetchUser(self, user: self.userModel!)
                    }
                }
            }
        }
    }
    
    func addNewMail(mail: MailModel) {
        if userModel?.otherEmails == nil {
            userModel?.otherEmails = [mail]
        } else {
            userModel?.otherEmails?.append(mail)
        }
    }
    
    func changeMail(mail: String, index: Int) {
        userModel?.otherEmails?[index].email = mail
    }
    
    func changeMailTitle(title: String, index: Int) {
        userModel?.otherEmails?[index].title = title
    }
    
    func removeMail(index: Int) {
        userModel?.otherEmails?.remove(at: index)
    }
    
    func addNewPhoneNumber(phoneNumber: PhoneNumberModel) {
        if userModel?.phoneNumbers == nil {
            userModel?.phoneNumbers = [phoneNumber]
        } else {
            userModel?.phoneNumbers?.append(phoneNumber)
        }
    }
    
    func changePhoneNumber(phoneNumber: String, index: Int) {
        userModel?.phoneNumbers?[index].phoneNumber = phoneNumber
    }
    
    func changePhoneNumberTitle(title: String, index: Int) {
        userModel?.phoneNumbers?[index].title = title
    }
    
    func removePhoneNumber(index: Int) {
        userModel?.phoneNumbers?.remove(at: index)
    }
    
    // Update database
    func updateUser() {
        guard userModel?.userID != nil else { return }
        do {
            try db.collection("userProfileInfo").document(userModel!.userID!).setData(from: userModel)
        } catch {
            print(error)
        }
    }
    
}

protocol UserManagerDelegate {
    func didFetchUser(_ userManager: UserManager, user: UserModel)
}
