//
//  InviteMemberViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 23.05.2021.
//

import UIKit

class InviteMemberViewController: UITableViewController, InvitedMembersDelegate, InviteMemberCellDelegate {
    
    var teamManager: TeamManager?
    private var invitedMembers: [UserModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
        teamManager?.invitedMembersDelegate = self
        teamManager?.getInvitedMembers()
    }
    
    @IBAction func reload(_ sender: UIBarButtonItem) {
        teamManager?.getInvitedMembers()
    }
    
    
    func didLoadInvitedMembers(_ teamManager: TeamManager, invitedMembers: [UserModel]) {
        self.invitedMembers = invitedMembers
        tableView.reloadData()
    }
    
    func inviteMember(with email: String) {
        teamManager?.inviteMember(with: email)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return invitedMembers?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "InviteMemberCell", for: indexPath) as! InviteMemberCell
            cell.delegate = self
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
            
            if let member = invitedMembers?[indexPath.row] {
                cell.emailLabel.text = member.email
                cell.nameLabel.text = member.profileName
            }
            
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Invited Users"
        }
        return nil
    }

}
