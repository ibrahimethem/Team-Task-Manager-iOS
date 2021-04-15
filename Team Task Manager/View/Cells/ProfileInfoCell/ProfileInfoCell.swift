//
//  ProfileInfoCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 25.03.2021.
//

import UIKit

class ProfileInfoCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var info: UITextField!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
