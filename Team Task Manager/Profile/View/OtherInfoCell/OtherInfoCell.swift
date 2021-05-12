//
//  OtherInfoCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 19.04.2021.
//

import UIKit

class OtherInfoCell: ProfileCell, UITextFieldDelegate {
    
    @IBOutlet weak var titleButton: UIButton!
    @IBOutlet weak var info: UITextField!
    var otherInfoCellDelegate: OtherInfoCellDelegate?
    
    override var key: UserModel.codingKeys? {
        didSet {
            switch key {
            case .otherEmails:
                titleButton.titleLabel?.text = "Other emails:"
                info.placeholder = "Enter your email"
                info.keyboardType = .emailAddress
                info.textContentType = .emailAddress
            case .phoneNumbers:
                titleButton.titleLabel?.text = "Phone #:"
                info.placeholder = "Add your phone number"
                info.keyboardType = .numbersAndPunctuation
                info.textContentType = .telephoneNumber
            default:
                print(key?.rawValue ?? "")
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        info.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func editTitle(_ sender: UIButton) {
        if let i = index {
            otherInfoCellDelegate?.titleButtonPressed(self, index: i)
        }
    }
    
    var initialText = ""
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        initialText = textField.text!
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if initialText != textField.text {
            delegate?.infoDidChange(self, info: textField.text!)
        }
    }
    
}


protocol OtherInfoCellDelegate {
    func titleButtonPressed(_ cell: OtherInfoCell, index: Int)
}

