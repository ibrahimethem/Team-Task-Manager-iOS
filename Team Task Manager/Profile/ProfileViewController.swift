//
//  ProfileViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 25.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class ProfileViewController: UITableViewController, UserManagerDelegate {
    
    var db: Firestore = Firestore.firestore()
    //var userModel: UserModel?
    var userManager: UserManager?
    
    var userModelSnapshot: ListenerRegistration?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        tableView.register(UINib(nibName: "BioCell", bundle: nil), forCellReuseIdentifier: "bioCell")
        
        // User Manager
        userManager = UserManager()
        userManager?.delegate = self
        userManager?.setListener()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        userManager?.userModelSnapshot?.remove()
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "editProfileSegue", sender: userManager)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editProfileSegue" {
            if let vc = segue.destination as? EditProfileViewController {
                vc.userManager = sender as? UserManager
            } else {
                print("Fail on prepare")
            }
        }
    }
    
}


// MARK: - User Manager Delegate


extension ProfileViewController {
    func didFetchUser(_ userManager: UserManager, user: UserModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}


// MARK: - Table view functions


extension ProfileViewController {
    
    enum sectionNumbers: Int {
        case profileName = 0
        case bio = 1
        case email = 2
        case otherMails = 3
        case phoneNumbers = 4
        // default case is LOGOUT
        case total = 6
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard userManager?.userModel != nil else {
            return 0
        }
        return sectionNumbers.total.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usrMdl = userManager?.userModel else {
            return 0
        }
        switch section {
        case sectionNumbers.profileName.rawValue:
            if usrMdl.profileName != nil { return 1 } else { return 0}
        case sectionNumbers.bio.rawValue:
            if usrMdl.bio != nil { return 1 } else { return 0}
        case sectionNumbers.email.rawValue:
            if usrMdl.email != nil { return 1 } else { return 0}
        case sectionNumbers.phoneNumbers.rawValue:
            if usrMdl.phoneNumbers != nil { return usrMdl.phoneNumbers!.count } else { return 0 }
        case sectionNumbers.otherMails.rawValue:
            if usrMdl.otherEmails != nil { return usrMdl.otherEmails!.count } else { return 0 }
        default:
            return 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let usrMdl = userManager?.userModel else {
            navigationController?.popViewController(animated: true)
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case sectionNumbers.profileName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Profile Name:"
            cell.info.text = usrMdl.profileName
            cell.info.placeholder = "Enter your profile name"
            cell.info.isUserInteractionEnabled = false
            
            return cell
            
        case sectionNumbers.bio.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! BioCell
            
            cell.titleLabel.text = "Bio:"
            cell.infoTextView.text = usrMdl.bio
            cell.infoTextView.isEditable = false
            
            return cell
            
        case sectionNumbers.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Email:"
            cell.info.text = usrMdl.email
            cell.info.placeholder = "Enter your email"
            cell.info.isUserInteractionEnabled = false
            
            return cell
            
        case sectionNumbers.otherMails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Other emails:"
            cell.info.text = usrMdl.otherEmails?[indexPath.row]
            cell.info.placeholder = "Enter your email"
            cell.info.isUserInteractionEnabled = false
            
            return cell
            
        case sectionNumbers.phoneNumbers.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Phone #:"
            cell.info.text = usrMdl.phoneNumbers?[indexPath.row]
            cell.info.placeholder = "Enter your phone number"
            cell.info.isUserInteractionEnabled = false
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "logoutCell", for: indexPath) as! LogoutCell
            
            return cell
        }
    
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if tableView.numberOfRows(inSection: section) == 0 || section == 5 {
            return UIView()
        } else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "logoutCell" {
            let alertView = UIAlertController(title: "Logout", message: "You are logging out. Do you want to continue?", preferredStyle: .alert)
            alertView.addAction(UIAlertAction(title: "Yes, continue", style: .destructive, handler: { (alertAction) in
                try? Auth.auth().signOut()
            }))
            alertView.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                alertView.dismiss(animated: true, completion: nil)
            }))
            self.present(alertView, animated: true, completion: nil)
        }
    }
}
