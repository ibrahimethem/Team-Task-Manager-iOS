//
//  TeamOverviewCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 25.05.2021.
//

import UIKit

class TeamOverviewCell: UITableViewCell, UITextViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var titleTextField: MyTextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var delegate: TeamOverviewCellDelegate?
    
    var textFieldInitialText: String?
    var textViewInitialText: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleTextField.delegate = self
        descriptionTextView.delegate = self
        setup()
    }
    
    private func setup() {
        let color = UIColor(named: "tabbar-color")!.cgColor
        
        titleTextField.layer.cornerRadius = 8.0
        titleTextField.layer.borderWidth = 1.0
        titleTextField.layer.borderColor = color
        
        descriptionTextView.layer.cornerRadius = 8.0
        descriptionTextView.layer.borderWidth = 1.0
        descriptionTextView.layer.borderColor = color
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textViewInitialText = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text != nil, textView.text != textViewInitialText {
            delegate?.updateTeamOverview(titleText: titleTextField.text!, descriptionText: textView.text!)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textFieldInitialText = textField.text
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil, textField.text != textFieldInitialText {
            delegate?.updateTeamOverview(titleText: textField.text!, descriptionText: descriptionTextView.text!)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
}

protocol TeamOverviewCellDelegate {
    func updateTeamOverview(titleText: String, descriptionText: String)
}
