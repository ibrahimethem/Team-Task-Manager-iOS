//
//  AppDelegate.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 11.03.2021.
//

import UIKit
import Firebase
import FirebaseFirestore
//import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //IQKeyboardManager.shared.enable = true
        //IQKeyboardManager.shared.enableAutoToolbar = false
        
        FirebaseApp.configure()
        
//        Firestore.firestore().clearPersistence { (err) in
//            if err != nil {
//                print(err as Any)
//            } else {
//                print("Clear")
//            }
//        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                let mainStoryBoard = UIStoryboard.init(name: "Home", bundle: nil)
                self.window?.rootViewController = mainStoryBoard.instantiateInitialViewController()
            } else {
                let loginRegisterStoryBoard = UIStoryboard.init(name: "Login", bundle: nil)
                self.window?.rootViewController = loginRegisterStoryBoard.instantiateInitialViewController()
            }
        }
        
        return true
    }



}

