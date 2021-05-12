//
//  AccountViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 7.05.2021.
//

import UIKit
import FirebaseAuth

class AccountViewController: UITableViewController, UserManagerDelegate {
    
    var userManager = UserManager()
    
    struct ViewModel {
        var user: UserModel?
    }
    
    private var viewModel = ViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userManager.delegate = self
        userManager.setListener()
    }
    
    func didFetchUser(_ userManager: UserManager, user: UserModel) {
        viewModel.user = user
        tableView.reloadSections(IndexSet(integer: 0), with: .fade)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileOverviewCell", for: indexPath)
            cell.textLabel?.text = viewModel.user?.profileName ?? ""
            cell.detailTextLabel?.text = viewModel.user?.email ?? ""
            
            return cell
        case 1:
            return tableView.dequeueReusableCell(withIdentifier: "LogoutCell", for: indexPath)
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            performSegue(withIdentifier: "ProfileViewSegue", sender: nil)
        case 1:
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

}
