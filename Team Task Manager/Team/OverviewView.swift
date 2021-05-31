//
//  OverviewView.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 24.05.2021.
//

import UIKit

class OverviewView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, TeamOverviewCellDelegate {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var teamOverview: TeamOverviewModel?
    var teamManager: TeamManager?

    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TeamOverviewCell", bundle: nil), forCellReuseIdentifier: "TeamOverviewCell")
        tableView.register(UINib(nibName: "GeneralInfoCell", bundle: nil), forCellReuseIdentifier: "GeneralInfoCell")
    }
    
    func updateTeamOverview(titleText: String, descriptionText: String) {
        teamManager?.updateOverview(name: titleText, description: descriptionText)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let team = teamOverview else { return UITableViewCell() }
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TeamOverviewCell") as! TeamOverviewCell
            
            cell.titleTextField.text = team.teamName
            cell.descriptionTextView.text = team.teamDescription
            cell.delegate = self
            
            return cell
        default:
            return UITableViewCell()
        }
    }

}
