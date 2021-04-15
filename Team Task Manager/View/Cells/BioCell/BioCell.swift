//
//  BioCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit

class BioCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoTextView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        infoTextView.textContainerInset = UIEdgeInsets(top: 18, left: 0, bottom: 18, right: 5)
        infoTextView.textContainer.lineFragmentPadding = 0.0
        
        //infoTextView.centerVerticalText()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension UITextView {

    func centerVerticalText() {
        self.textAlignment = .center
        let fitSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
        let size = sizeThatFits(fitSize)
        let calculate = (bounds.size.height - size.height * zoomScale) / 2
        let offset = max(1, calculate)
        contentOffset.y = -offset
    }
}
