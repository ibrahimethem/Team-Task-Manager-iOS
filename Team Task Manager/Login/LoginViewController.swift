//
//  LoginViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 23.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class LoginViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Outlets
    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    
    @IBOutlet weak var warningTextView: UITextView!
    @IBOutlet weak var warningView: UIView!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        setupFirestore()
        
    }

    private func setupFirestore() {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
    }
    
    private func setupTextFields() {
        warningView.isHidden = true
    }
    
    @IBAction func signUp(_ sender: UIButton) {
        if password.text != confirmPassword.text {
            showError(errorText: "passwords did not match")
            resetView()
        }
        Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (authDataResult, error) in
            if let err = error {
                self.showError(errorText: err.localizedDescription)
                DispatchQueue.main.async {
                    self.resetView()
                }
                return
            }
            if let result = authDataResult {
                print("Profile Name: \(self.profileName.text!), signed up. \(result.user)")
                let usr = UserModel(userID: result.user.uid ,profileName: self.profileName.text, email: result.user.email)
                DispatchQueue.init(label: "profileUpdate").async {
                    self.updateProfileInfo(user: usr)
                }
            }
        }
    }
    
    private func updateProfileInfo(user: UserModel) {
        db.collection("userProfileInfo").document(user.userID).setData(user.asDictionary()) { (err) in
            if let error = err {
                print(error.localizedDescription)
            }
        }
    }
    
    private func showError(errorText: String) {
        warningView.isHidden = false
        warningTextView.text = errorText
    }
    
    private func resetView() {
        profileName.text = ""
        email.text = ""
        password.text = ""
        confirmPassword.text = ""
    }
    
}
