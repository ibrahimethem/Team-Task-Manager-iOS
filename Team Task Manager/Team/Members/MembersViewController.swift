//
//  MembersViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 22.05.2021.
//

import UIKit

class MembersViewController: UITableViewController {
    
    var members: [UserModel]?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemberCell", for: indexPath) as! MemberCell
        
        let usr = members![indexPath.row]
        cell.nameLabel.text = usr.profileName
        cell.emailLabel.text = usr.email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            performSegue(withIdentifier: "MemberDetailSegue", sender: members?[indexPath.row])
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? MemberDetailViewController, let member = sender as? UserModel {
            dest.member = member
        }
    }
}
