//
//  MemberCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 22.05.2021.
//

import UIKit

class MemberCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
