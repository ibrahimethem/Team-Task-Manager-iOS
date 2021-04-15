//
//  EditProfileViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 10.04.2021.
//

import UIKit

class EditProfileViewController: UIViewController {

    @IBOutlet weak var editTableView: UITableView!
    
    var userModel: UserModel?
    var userManager: UserManager? {
        didSet {
            self.userModel = userManager?.userModel
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        editTableView.delegate = self
        editTableView.dataSource = self
        
        editTableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        editTableView.register(UINib(nibName: "BioCell", bundle: nil), forCellReuseIdentifier: "bioCell")
        editTableView.register(UITableViewCell.self, forCellReuseIdentifier: "addMoreCell")
        
        editTableView.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    enum sectionNumbers: Int {
        case profileName = 0
        case bio = 1
        case email = 2
        case otherMails = 3
        case phoneNumbers = 4
        
        case total = 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard userModel != nil else {
            return 0
        }
        return sectionNumbers.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usrMdl = userModel else {
            return 0
        }
        switch section {
        case sectionNumbers.profileName.rawValue:
            return 1
        case sectionNumbers.bio.rawValue:
            return 1
        case sectionNumbers.email.rawValue:
            return 1
        case sectionNumbers.otherMails.rawValue:
            return (usrMdl.otherEmails?.count ?? 0) + 1
        case sectionNumbers.phoneNumbers.rawValue:
            return (usrMdl.phoneNumbers?.count ?? 0) + 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let usrMdl = userModel else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case sectionNumbers.profileName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Profile Name:"
            cell.info.text = usrMdl.profileName
            cell.info.placeholder = "Add your profile name"
            cell.info.textContentType = .name
            
            return cell
        
        case sectionNumbers.bio.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! BioCell
            
            cell.titleLabel.text = "Bio:"
            cell.infoTextView.text = usrMdl.bio ?? ""
            cell.infoTextView.isEditable = true
            
            return cell
        
        case sectionNumbers.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Email:"
            cell.info.text = usrMdl.email
            cell.info.placeholder = "Add your email"
            cell.info.keyboardType = .emailAddress
            cell.info.textContentType = .emailAddress
            
            return cell
            
        case sectionNumbers.otherMails.rawValue:
            if (usrMdl.otherEmails?.count ?? 0) == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell", for: indexPath)
                cell.textLabel?.text = "Add another email"
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Other emails:"
            cell.info.text = usrMdl.otherEmails?[indexPath.row]
            cell.info.placeholder = "Enter your email"
            cell.info.keyboardType = .emailAddress
            cell.info.textContentType = .emailAddress
            
            return cell
            
        case sectionNumbers.phoneNumbers.rawValue:
            if (usrMdl.phoneNumbers?.count ?? 0) == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell", for: indexPath)
                cell.textLabel?.text = "Add another phone number"
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.titleLabel.text = "Phone #:"
            cell.info.text = usrMdl.phoneNumbers?[indexPath.row]
            cell.info.placeholder = "Add your phone number"
            cell.info.keyboardType = .phonePad
            cell.info.textContentType = .telephoneNumber
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
}
