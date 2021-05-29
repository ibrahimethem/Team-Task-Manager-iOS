//
//  TaskCommentCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 20.05.2021.
//

import UIKit

class TaskCommentCell: UITableViewCell {
    
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentTextView: UITextView!

    override func awakeFromNib() {
        super.awakeFromNib()
        commentTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        commentTextView.textContainer.lineFragmentPadding = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
