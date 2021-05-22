//
//  MemberDetailViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 22.05.2021.
//

import UIKit

class MemberDetailViewController: UITableViewController {
    
    enum sectionNumbers: Int {
        case profileName = 0
        case bio = 1
        case email = 2
        case otherMails = 3
        case phoneNumbers = 4
    }
    
    var member: UserModel?
    
    var defaultHeaderHeight: CGFloat = 18

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ProfileInfoCell", bundle: nil), forCellReuseIdentifier: "profileInfoCell")
        tableView.register(UINib(nibName: "BioCell", bundle: nil), forCellReuseIdentifier: "bioCell")
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case sectionNumbers.otherMails.rawValue:
            return member?.otherEmails?.count ?? 0
        case sectionNumbers.phoneNumbers.rawValue:
            return member?.phoneNumbers?.count ?? 0
        case sectionNumbers.bio.rawValue:
            if member?.bio != nil {
                return 1
            } else {
                return 0
            }
        default:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case sectionNumbers.profileName.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            cell.titleLabel.text = "Name:"
            cell.info.text = member?.profileName
            return cell
        case sectionNumbers.bio.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "bioCell", for: indexPath) as! BioCell
            cell.titleLabel.text = "Bio"
            cell.infoTextView.text = member?.bio
            return cell
        case sectionNumbers.email.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            cell.titleLabel.text = "Email:"
            cell.info.text = member?.email
            return cell
        case sectionNumbers.otherMails.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            if let otherMail = member?.otherEmails?[indexPath.row] {
                cell.titleLabel.text = "\(otherMail.title ?? "Other"):"
                cell.info.text = otherMail.email
            }
            return cell
        case sectionNumbers.phoneNumbers.rawValue:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell", for: indexPath) as! ProfileInfoCell
            if let phoneNumber = member?.phoneNumbers?[indexPath.row] {
                cell.titleLabel.text = "\(phoneNumber.title ?? "Other"):"
                cell.info.text = phoneNumber.phoneNumber
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case sectionNumbers.bio.rawValue:
            if member?.bio == nil {
                return CGFloat.leastNormalMagnitude
            }
        case sectionNumbers.otherMails.rawValue:
            if member?.otherEmails == nil {
                return CGFloat.leastNormalMagnitude
            }
        case sectionNumbers.phoneNumbers.rawValue:
            if member?.phoneNumbers == nil {
                return CGFloat.leastNormalMagnitude
            }
        default:
            return defaultHeaderHeight
        }
        return defaultHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        switch section {
        case sectionNumbers.bio.rawValue:
            if member?.bio == nil {
                return CGFloat.leastNormalMagnitude
            }
        case sectionNumbers.otherMails.rawValue:
            if member?.otherEmails == nil {
                return CGFloat.leastNormalMagnitude
            }
        case sectionNumbers.phoneNumbers.rawValue:
            if member?.phoneNumbers == nil {
                return CGFloat.leastNormalMagnitude
            }
        default:
            return defaultHeaderHeight
        }
        return defaultHeaderHeight
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case sectionNumbers.otherMails.rawValue:
            if member?.otherEmails != nil {
                return "Other emails"
            }
        case sectionNumbers.phoneNumbers.rawValue:
            if member?.phoneNumbers != nil {
                return "Phone Numbers"
            }
        default:
            return nil
        }
        return nil
    }
}
