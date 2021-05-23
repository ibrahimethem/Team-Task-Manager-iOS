//
//  InviteMemberCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 23.05.2021.
//

import UIKit

class InviteMemberCell: UITableViewCell {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var inviteButton: UIButton!
    
    var delegate: InviteMemberCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    
    @IBAction func invite(_ sender: UIButton) {
        if let text = textField.text {
            delegate?.inviteMember(with: text)
        }
    }
    
}

protocol InviteMemberCellDelegate {
    func inviteMember(with email: String)
}
