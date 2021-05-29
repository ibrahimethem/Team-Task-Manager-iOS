//
//  AddCommentCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 27.05.2021.
//

import UIKit

class AddCommentCell: UITableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    
    var delegate: AddCommentDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        textField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text != "" {
            delegate?.addComment(with: text)
            textField.text = ""
            return true
        } else if textField.text == "" {
            print("You need to add comment")
            return false
        }
        return false
    }

}

protocol AddCommentDelegate {
    func addComment(with text: String)
}
