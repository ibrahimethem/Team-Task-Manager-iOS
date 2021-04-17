//
//  BioCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit

class BioCell: ProfileCell, UITextViewDelegate {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoTextView.textContainerInset = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 5)
        infoTextView.textContainer.lineFragmentPadding = 0.0
        
        infoTextView.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private var initialText: String?
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        initialText = textView.text
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if initialText != textView.text {
            delegate?.infoDidChange(self as ProfileCell, info: textView.text)
        }
    }
    
}
