//
//  ChatInfoCellCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 4.06.2021.
//

import UIKit

class ChatInfoCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        infoLabel.layer.cornerRadius = 13.0
        infoLabel.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }

}
