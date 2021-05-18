//
//  TeamSectionHeaderView.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 19.05.2021.
//

import UIKit

class TeamSectionHeaderView: UIView {
    
    var contentview: UIView?
    let nibName = "TeamSectionHeaderView"

    @IBOutlet weak var textField: UITextField!
    
    @IBAction func more(_ sender: UIButton) {
        print(textField.text!)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentview = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
    
}
