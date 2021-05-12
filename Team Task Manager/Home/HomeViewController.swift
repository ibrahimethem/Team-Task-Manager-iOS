//
//  HomeViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit
import SideMenu
import FirebaseAuth

struct HomeViewModel {
    var teams: [TeamModel]?
    var userInfo: UserModel?
}

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TeamManagerDelegate {

    lazy var teamManager = TeamManager()
    lazy var viewModel = HomeViewModel()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamManager.delegate = self
        //teamManager.addSnapshotListener()
        teamManager.loadViewModel()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    func didLoadTeams(_ teamManager: TeamManager, teams: [TeamModel]) {
        viewModel.teams = teams
        tableView.reloadData()
    }
    
    func didModifyTeam(_ teamManager: TeamManager, team: TeamModel) {
        print(team)
    }
    
    func didAddTeam(_ teamManager: TeamManager, team: TeamModel) {
        print(team)
    }
    
    func didRemoveTeam(_ teamManager: TeamManager, team: TeamModel) {
        print(team)
    }
    
    func didFailLoadTeams(_ teamManager: TeamManager, with error: Error) {
        print(error)
    }
    
    func didLoadUser(_ teamManager: TeamManager, user: UserModel) {
        //viewModel.userInfo = user
        //tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
    
    func didLoadViewModel(_ teamManager: TeamManager) {
        viewModel.teams = teamManager.teams
        viewModel.userInfo = teamManager.user
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.teams?.count ?? 0
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTeamCell", for: indexPath) as! HomeTeamCell
            if let tempTeam = viewModel.teams?[indexPath.row] {
                cell.titleLabel.text = tempTeam.teamName
                cell.detailsTextView.text = tempTeam.id
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "TeamViewSegue", sender: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

}

protocol HomeViewControllerDelegate {
    func didSelectTeam(team: TeamModel)
    func didAddNewTeam(team: TeamModel)
    func didSellectProfile()
}
