//
//  HomeViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, MenuViewControllerDelegate {

    var menu: SideMenuNavigationController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menu = SideMenuNavigationController(rootViewController: MenuViewController(delegateViewController: self) )
        menu?.leftSide = true
        
        SideMenuManager.default.leftMenuNavigationController = menu
        SideMenuManager.default.addPanGestureToPresent(toView: self.view)
        
    }
    
    
    // MARK: - Menu functions
    
    @IBAction func menuButton(_ sender: UIBarButtonItem) {
        present(menu!, animated: true, completion: nil)
    }
    
    func didSelectAnItemFromMenu(menuItem: MenuItem) {
        switch menuItem {
        case .profile:
            performSegue(withIdentifier: "profileSegue", sender: nil)
        default:
            print(menuItem.hashValue)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}
