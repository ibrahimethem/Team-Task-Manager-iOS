//
//  NewTaskCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 16.05.2021.
//

import UIKit

class NewTaskCell: UITableViewCell, UITextViewDelegate {
    
    @IBOutlet weak var stackContainerView: UIStackView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailsTextView: UITextView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegateTable: NewTaskCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        detailsTextView.delegate = self
        detailsTextView.textContainer.lineFragmentPadding = 0.0
        detailsTextView.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        stackContainerView.layer.cornerRadius = 10
        
        detailsTextView.text = "Add details"
        detailsTextView.font = UIFont.italicSystemFont(ofSize: 14)
        detailsTextView.textColor = .gray
        titleTextField.becomeFirstResponder()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .gray {
            textView.text = ""
            textView.font = UIFont.systemFont(ofSize: 14, weight: .light)
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Add details"
            textView.font = UIFont.italicSystemFont(ofSize: 14)
            textView.textColor = .gray
        }
    }
    
    
    @IBAction func add(_ sender: UIButton) {
        var details = ""
        if detailsTextView.textColor == .black {
            details = detailsTextView.text
        }
        delegateTable?.didAddNewTask(title: titleTextField.text ?? "", details: details)
        cleanTexts()
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        endEditing(true)
        delegateTable?.didCancelNewTask()
        cleanTexts()
    }
    
    private func cleanTexts() {
        titleTextField.text = ""
        detailsTextView.text = "Add details"
        detailsTextView.font = UIFont.italicSystemFont(ofSize: 14)
        detailsTextView.textColor = .gray
    }
    
}

protocol NewTaskCellDelegate {
    func didCancelNewTask()
    func didAddNewTask(title: String, details: String)
}
