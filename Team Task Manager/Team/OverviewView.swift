//
//  OverviewView.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 24.05.2021.
//

import UIKit

class OverviewView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var teamOverview: TeamOverviewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let team = teamOverview else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.textLabel?.text = team.teamName
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel?.text = team.teamDescription
                return cell
            }
        case 1:
            if indexPath.row == 0 {
                let cell = UITableViewCell()
                cell.textLabel?.text = "\(team.newTasks) new tasks"
                return cell
            } else {
                let cell = UITableViewCell()
                cell.textLabel?.text = " \(team.newMessages) new messages"
                return cell
            }
        default:
            return UITableViewCell()
        }
    }

}
