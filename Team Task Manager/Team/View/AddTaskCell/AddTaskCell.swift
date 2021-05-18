//
//  AddTaskCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 13.05.2021.
//

import UIKit

class AddTaskCell: UITableViewCell {

    @IBOutlet weak var containerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        containerStackView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
