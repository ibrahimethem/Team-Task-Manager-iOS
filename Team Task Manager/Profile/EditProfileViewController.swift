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
            userModel = userManager?.userModel
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
        
        editTableView.isEditing = true
        
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        dismiss(animated: true) {
            DispatchQueue.main.async {
                self.userManager?.updateUser()
            }
        }
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: {
            self.userManager?.userModel = self.userModel
        })
    }
    
    
}

extension EditProfileViewController: UITableViewDelegate, UITableViewDataSource, ProfileCellDelegate {

    func infoDidChange(_ cell: ProfileCell, info: String) {
        switch cell.key {
        case .profileName:
            userManager?.userModel?.profileName = info
        case .bio:
            userManager?.userModel?.bio = info
        case .otherEmails:
            if let i = cell.index {
                userManager?.changeMail(mail: info, index: i)
            }
        case .phoneNumbers:
            if let i = cell.index {
                userManager?.changePhoneNumber(phoneNumber: info, index: i)
            }
        default:
            print(info)
        }
        print(userManager?.userModel?.dict ?? "")
    }
    
    enum sectionNumbers: Int {
        case profileName = 0
        case bio = 1
        case email = 2
        case otherMails = 3
        case phoneNumbers = 4
        
        case total = 5
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        guard userManager?.userModel != nil else {
            return 0
        }
        return sectionNumbers.total.rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let usrMdl = userManager?.userModel else {
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
        guard let usrMdl = userManager?.userModel else {
            return UITableViewCell()
        }
        
        switch indexPath.section {
        case sectionNumbers.profileName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.info.text = usrMdl.profileName
            cell.key = UserModel.codingKeys.profileName
            cell.delegate = self
            
            return cell
        
        case sectionNumbers.bio.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! BioCell
            
            cell.titleLabel.text = "Bio:"
            cell.infoTextView.text = usrMdl.bio ?? ""
            cell.infoTextView.isEditable = true
            cell.delegate = self
            
            return cell
        
        case sectionNumbers.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.info.text = usrMdl.email
            cell.key = UserModel.codingKeys.email
            //cell.delegate = self
            
            return cell
            
        case sectionNumbers.otherMails.rawValue:
            if (usrMdl.otherEmails?.count ?? 0) == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell", for: indexPath)
                cell.textLabel?.text = "Add another email"
                
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.info.text = usrMdl.otherEmails?[indexPath.row]
            cell.key = UserModel.codingKeys.otherEmails
            cell.delegate = self
            cell.index = indexPath.row
            
            return cell
            
        case sectionNumbers.phoneNumbers.rawValue:
            if (usrMdl.phoneNumbers?.count ?? 0) == indexPath.row {
                let cell = tableView.dequeueReusableCell(withIdentifier: "addMoreCell", for: indexPath)
                cell.textLabel?.text = "Add another phone number"
                
                return cell
            }
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            
            cell.info.text = usrMdl.phoneNumbers?[indexPath.row]
            cell.key = UserModel.codingKeys.phoneNumbers
            cell.delegate = self
            cell.index = indexPath.row
            
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.cellForRow(at: indexPath)?.reuseIdentifier == "addMoreCell" {
            if indexPath.section == sectionNumbers.otherMails.rawValue {
                userManager?.addNewMail(mail: "")
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                tableView.reloadData()
            } else if indexPath.section == sectionNumbers.phoneNumbers.rawValue {
                userManager?.addNewPhoneNumber(phoneNumber: "")
                tableView.reloadSections(IndexSet(integer: indexPath.section), with: .automatic)
                tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        switch indexPath.section {
        case sectionNumbers.otherMails.rawValue:
            if userManager?.userModel?.otherEmails?.count == indexPath.row { return false }
            return true
        case sectionNumbers.phoneNumbers.rawValue:
            if userManager?.userModel?.phoneNumbers?.count == indexPath.row { return false }
            return true
        default:
            return false
        }
    }
    
}
