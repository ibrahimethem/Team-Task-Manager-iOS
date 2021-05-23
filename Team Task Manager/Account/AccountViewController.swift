//
//  AccountViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 7.05.2021.
//

import UIKit
import FirebaseAuth

class AccountViewController: UITableViewController, UserManagerDelegate, AccountManagerDelegate {
    
    lazy var userManager = UserManager()
    lazy var accountManager = AccountManager()
    
    struct ViewModel {
        var user: UserModel?
    }
    
    var invites: [TeamOverViewModel]?
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        userManager.setListener()
        
        accountManager.delegate = self
        //accountManager.addSnapshotListener()
    }
    
    func didFetchUser(_ userManager: UserManager, user: UserModel) {
        viewModel.user = user
        accountManager.user = user
        accountManager.addSnapshotListener()
        tableView.reloadData()
    }
    
    func didLoadInvites(_ accountManager: AccountManager, teamOverViews: [TeamOverViewModel]) {
        invites = teamOverViews
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if viewModel.user != nil {
                return 1
            } else {
                return 0
            }
        case 1:
            return invites?.count ?? 0
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOverviewCell", for: indexPath)
            cell.textLabel?.text = viewModel.user?.profileName ?? ""
            cell.detailTextLabel?.text = viewModel.user?.email ?? ""
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AccountTeamCell", for: indexPath)
            if let invite = invites?[indexPath.row] {
                cell.textLabel?.text = invite.teamName
                cell.detailTextLabel?.text = invite.teamDescription
            }
            
            return cell
        default:
            return tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(25)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "ProfileViewSegue", sender: nil)
        case 1:
            print("\(invites?[indexPath.row].teamName ?? "no team") selected.")
        case 2:
            let alertView = UIAlertController(title: "Logout", message: "You are logging out. Do you want to continue?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes, continue", style: .destructive, handler: { (alertAction) in
                try? Auth.auth().signOut()
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                alertView.dismiss(animated: true, completion: nil)
            }))
            self.present(alertView, animated: true, completion: nil)
        default:
            print("Cell selected with indexpath: \(indexPath)")
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Profile"
        case 1:
            return "Invites"
        default:
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.section == 1 {
            let acceptAction = UITableViewRowAction(style: .default, title: "Accept") { action, indexPath in
                if let docID = self.invites?[indexPath.row].id {
                    self.accountManager.acceptInvite(docID: docID)
                }
            }
            acceptAction.backgroundColor = UIColor.systemGreen
            let declineAction = UITableViewRowAction(style: .default, title: "Decline") { action, indexPath in
                if let docID = self.invites?[indexPath.row].id {
                    self.accountManager.declineInvite(docID: docID)
                }
            }
            declineAction.backgroundColor = UIColor.systemRed
            return [acceptAction, declineAction]
        }
        
        return nil
    }

}
