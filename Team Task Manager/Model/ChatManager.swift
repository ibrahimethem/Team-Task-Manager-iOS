//
//  ChatManager.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 30.05.2021.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatManager {
    
    var teamID: String?
    var messages: [MessageModel]?
    
    var delegate: ChatManagerDelegate?
    var chatViewDelegate: ChatViewDelegate?
    
    var db: Firestore {
        let settings = FirestoreSettings()
        let tempDB = Firestore.firestore()
        tempDB.settings = settings
        
        return tempDB
    }
    
    func addSnapshotListener() {
        guard let tid = teamID else { return }
        
        db.collection("Chats").whereField("teamID", isEqualTo: tid).order(by: "date", descending: true).limit(to: 10).addSnapshotListener { querySnapshot, error in
            
            if let err = error as NSError? {
                print(err)
            }
            
            if let documents = querySnapshot?.documents {
                let myMessages = documents.compactMap { (queryDocumentSnapshot) -> MessageModel? in
                    return try? queryDocumentSnapshot.data(as: MessageModel.self)
                }
                self.messages = myMessages
                self.delegate?.didLoadMessages(self, messages: self.messages!)
                self.chatViewDelegate?.didUpdateMessages(self)
            }
        }
    }
    
    func sendMessage(userID: String, message: String) {
        guard teamID != nil else { return }
        let messageModel = MessageModel(id: nil, teamID: teamID!, userID: userID, date: Timestamp(), message: message)
        
        do {
            let _ = try db.collection("Chats").addDocument(from: messageModel)
        } catch {
            print(error)
        }
    }
}

protocol ChatManagerDelegate {
    func didLoadMessages(_ chatManager: ChatManager, messages: [MessageModel])
}

protocol ChatViewDelegate {
    func didUpdateMessages(_ chatManager: ChatManager)
}
