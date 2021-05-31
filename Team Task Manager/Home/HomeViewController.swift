//
//  HomeViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 28.03.2021.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

struct HomeViewModel {
    var teams: [TeamModel]?
    var userInfo: UserModel?
}

class HomeViewController: UITableViewController, HomeManagerDelegate {

    lazy var homeManager = HomeManager()
    lazy var viewModel = HomeViewModel()
    
    //@IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeManager.delegate = self
        homeManager.addSnapshotListener()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true

    }
    
    @IBAction func addTeam(_ sender: UIButton) {
        performSegue(withIdentifier: "AddTeamSegue", sender: homeManager)
//        guard let userID = Auth.auth().currentUser?.uid else { return }
//        homeManager.addTeam(teamModel: TeamModel(id: nil, teamName: "New Team", teamDescription: "My awesom new team", adminID: userID, members: [userID], invitedMembers: [], membersInfo: [MemberInfo(userID: userID, joinDate: Timestamp())], sections: []))
    }
    
    func didLoadTeams(_ teamManager: HomeManager, teams: [TeamModel]) {
        viewModel.teams = teams
        tableView.reloadData()
    }
    
    func didModifyTeam(_ teamManager: HomeManager, team: TeamModel) {
        viewModel.teams = teamManager.teams
        tableView.reloadData()
    }
    
    func didAddTeam(_ teamManager: HomeManager, team: TeamModel) {
        viewModel.teams = teamManager.teams
        tableView.reloadData()
    }
    
    func didRemoveTeam(_ teamManager: HomeManager, team: TeamModel) {
        viewModel.teams = teamManager.teams
        tableView.reloadData()
    }
    
    func didFailLoadTeams(_ teamManager: HomeManager, with error: Error) {
        print("didFail")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.teams?.count ?? 0
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTeamCell", for: indexPath) as! HomeTeamCell
            if let tempTeam = viewModel.teams?[indexPath.row] {
                cell.titleLabel.text = tempTeam.teamName
                cell.detailsTextView.text = tempTeam.teamDescription
            }
            
            return cell
            
        default:
            return UITableViewCell()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let teamID = viewModel.teams?[indexPath.row].id {
            performSegue(withIdentifier: "TeamViewSegue", sender: teamID)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let id = sender as? String, let vc = segue.destination as? TeamViewController {
            vc.teamID = id
        } else if let hm = sender as? HomeManager, let vc = segue.destination as? AddTeamViewController {
            vc.homeManager = hm
        }
    }

}
