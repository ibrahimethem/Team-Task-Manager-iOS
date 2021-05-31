//
//  ChatCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 30.05.2021.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    
    var isOwnMessage: Bool? {
        didSet {
            if isOwnMessage != nil ,isOwnMessage! {
                rightConstraint.constant = 0.0
                leftConstraint.constant = 70.0
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
