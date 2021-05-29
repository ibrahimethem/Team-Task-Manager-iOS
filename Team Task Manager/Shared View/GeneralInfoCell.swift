//
//  GeneralInfoCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 27.05.2021.
//

import UIKit

class GeneralInfoCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}
