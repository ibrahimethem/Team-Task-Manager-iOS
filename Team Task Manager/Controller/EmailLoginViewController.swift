//
//  EmailLoginViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 11.03.2021.
//

import UIKit
import FirebaseAuth

class EmailLoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var warningView: UIView!
    @IBOutlet weak var warningTextView: UITextView!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        
    }
    
    private func setupTextFields() {
        warningView.isHidden = true
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: email.text!, password: password.text!) { (authDataREsult, error) in
            
            if let err = error {
                print(err)
                self.showError(errorText: err.localizedDescription)
                return
            }
            
            print("user signed in.")
            
        }
    }
    
    private func showError(errorText: String) {
        warningView.isHidden = false
        warningTextView.text = errorText
    }
    
}

