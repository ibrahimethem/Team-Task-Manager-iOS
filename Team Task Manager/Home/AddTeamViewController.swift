//
//  AddTeamViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 30.05.2021.
//

import UIKit
import FirebaseAuth

class AddTeamViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var homeManager: HomeManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        let color = UIColor(named: "tabbarItemColor")!.cgColor
        
        titleTextField.layer.cornerRadius = 8.0
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = color
        
        descriptionTextView.layer.cornerRadius = 8.0
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = color
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let teamModel = TeamModel(id: nil, teamName: titleTextField.text!, teamDescription: descriptionTextView.text!, adminID: userID, members: [userID], invitedMembers: nil, membersInfo: [], sections: [])
        homeManager?.addTeam(teamModel: teamModel)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}
