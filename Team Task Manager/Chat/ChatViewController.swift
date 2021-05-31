//
//  ChatViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 30.05.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, ChatViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var chatManager: ChatManager? {
        didSet {
            chatManager?.chatViewDelegate = self
        }
    }
    var members: [UserModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.transform = CGAffineTransform(rotationAngle: .pi)
        tableView.scrollIndicatorInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: tableView.bounds.size.width - 8.0)
    }
    
    @IBAction func send(_ sender: UIButton) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        guard let message = messageField.text else { return }
        chatManager?.sendMessage(userID: userID, message: message)
        messageField.text = ""
    }
    
    func didUpdateMessages(_ chatManager: ChatManager) {
        tableView.reloadData()
    }
    
    // MARK: Table View Delegate & Datasource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let messageCount = chatManager?.messages?.count {
            return messageCount
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let userID = Auth.auth().currentUser?.uid else { return UITableViewCell() }
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        if let message = chatManager?.messages?[indexPath.row] {
            if message.userID == userID {
                cell.isOwnMessage = true
            }
            if let user = members?.first(where: { $0.id == message.userID }) {
                cell.userNameLabel.text = user.profileName
            } else {
                cell.userNameLabel.text = "Unknown User"
            }
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.doesRelativeDateFormatting = true
            
            let date = message.date.dateValue()
            cell.dateLabel.text = formatter.string(from: date)
            cell.messageLabel.text = message.message
        }
        cell.transform = CGAffineTransform(rotationAngle: .pi)
        
        return cell
    }
    
}
