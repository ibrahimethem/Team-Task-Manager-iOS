//
//  HomeTeamCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 24.04.2021.
//

import UIKit

class HomeTeamCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailsTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTextView.textContainerInset = .init(top: 4.0, left: 0.0, bottom: 4.0, right: 0.0)
        detailsTextView.textContainer.lineFragmentPadding = 0.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
