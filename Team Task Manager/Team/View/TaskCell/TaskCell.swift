//
//  TaskCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 12.05.2021.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailTextView.textContainerInset = .init(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        detailTextView.textContainer.lineFragmentPadding = 0.0
        
        stackContainerView.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
