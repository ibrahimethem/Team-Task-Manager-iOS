//
//  TaskDetailInfoCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 20.05.2021.
//

import UIKit

class TaskDetailInfoCell: UITableViewCell {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var creatorLabel: UILabel!
    @IBOutlet weak var creationDate: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTextView.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        detailsTextView.textContainer.lineFragmentPadding = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
