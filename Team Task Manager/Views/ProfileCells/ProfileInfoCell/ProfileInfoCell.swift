//
//  ProfileInfoCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 25.03.2021.
//

import UIKit

class ProfileInfoCell: ProfileCell, UITextFieldDelegate {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var info: UITextField! {
        didSet {
            info.delegate = self
        }
    }
    
    override var key: UserModel.codingKeys? {
        didSet {
            switch key {
            case .profileName:
                titleLabel.text = "Profile Name:"
                info.placeholder = "Add your profile name"
                info.textContentType = .name
            case .email:
                titleLabel.text = "Email:"
                isUserInteractionEnabled = false
            case .otherEmails:
                titleLabel.text = "Other emails:"
                info.placeholder = "Enter your email"
                info.keyboardType = .emailAddress
                info.textContentType = .emailAddress
            case .phoneNumbers:
                titleLabel.text = "Phone #:"
                info.placeholder = "Add your phone number"
                info.keyboardType = .phonePad
                info.textContentType = .telephoneNumber
            default:
                print("\(self) key set: \(key?.rawValue ?? "")")
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func infoDidChange(_ sender: UITextField) {
        if key != nil {
            delegate?.infoDidChange(self as ProfileCell,info: sender.text!)
        } else {
            print("You need to initialize cell key")
        }
    }
    
    
}
