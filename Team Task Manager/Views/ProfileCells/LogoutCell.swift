//
//  LogoutCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 16.04.2021.
//

import UIKit

class LogoutCell: UITableViewCell {

    @IBOutlet weak var logoutLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        logoutLabel.text = "yey"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
