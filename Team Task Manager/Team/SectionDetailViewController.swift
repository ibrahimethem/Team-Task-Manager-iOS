//
//  SectionDetailViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 20.05.2021.
//

import UIKit

class SectionDetailViewController: UIViewController {
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var containerStack: UIStackView!
    
    var sectionIndex: IndexPath?
    var sectionModel: SectionModel?
    var presentingVC: TeamViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        containerStack.layer.cornerRadius = 10
        reloadViews()
        titleTextField.becomeFirstResponder()
    }
    
    func reloadViews() {
        titleTextField.text = sectionModel?.title
    }

    @IBAction func done(_ sender: UIButton) {
        if sectionModel != nil, let vc = presentingVC, sectionIndex != nil {
            sectionModel?.title = titleTextField.text
            vc.teamManager.updateSection(sectionIndex: sectionIndex!, section: sectionModel!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func remove(_ sender: UIButton) {
        if let vc = presentingVC {
            vc.teamManager.removeSection(sectionIndex: sectionIndex!)
        }
        dismiss(animated: true, completion: nil)
    }
    
}
