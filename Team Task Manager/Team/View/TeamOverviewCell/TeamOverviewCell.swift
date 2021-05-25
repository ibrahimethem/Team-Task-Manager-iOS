//
//  TeamOverviewCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 25.05.2021.
//

import UIKit

class TeamOverviewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextfield: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate: TeamOverviewCellDelegate?
    
    var textFieldInitialText: String?
    var textViewInitialText: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextfield.delegate = self
        descriptionTextView.delegate = self
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
        descriptionTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}

protocol TeamOverviewCellDelegate {
    func updateTeamOverview(titleText: String, descriptionText: String)
}
