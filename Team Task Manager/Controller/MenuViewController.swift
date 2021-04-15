//
//  MenuViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit

class MenuViewController: UITableViewController {

    let items = ["Profile", "Settings", "Logout"]
    
    var delegate: MenuViewControllerDelegate?
    
    init(delegateViewController: MenuViewControllerDelegate) {
        delegate = delegateViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.isNavigationBarHidden = true
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = items[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true, completion: nil)
        switch indexPath.row {
        case 0:
            delegate?.didSelectAnItemFromMenu(menuItem: .profile)
        case 1:
            delegate?.didSelectAnItemFromMenu(menuItem: .settings)
        default:
            delegate?.didSelectAnItemFromMenu(menuItem: .logout)
        }
    }
    
}

protocol MenuViewControllerDelegate {
    func didSelectAnItemFromMenu(menuItem: MenuItem)
}

enum MenuItem {
    case profile
    case settings
    case logout
}
