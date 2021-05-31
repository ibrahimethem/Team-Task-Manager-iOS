//
//  TeamViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 11.05.2021.
//

import UIKit
import FirebaseAuth

enum TeamViewSection: Int {
    case overView = 0
    case tasks = 1
    case newSection = 2
}

class TeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TeamManagerDelegate, ChatManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var columnNumberLabel: UILabel!
    @IBOutlet weak var membersButton: UIBarButtonItem!
    @IBOutlet weak var chatButton: UIBarButtonItem!
    
    var teamID: String?
    lazy var teamManager = TeamManager(delegate: self)
    var chatManager: ChatManager?
    
    var teamModel: TeamModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SectionView", bundle: nil), forCellWithReuseIdentifier: "SectionView")
        collectionView.register(UINib(nibName: "OverviewView", bundle: nil), forCellWithReuseIdentifier: "OverviewView")
        navigationController?.navigationBar.prefersLargeTitles = true
        
        teamManager.addSnapshotListener()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        reloadColumnNumber()
        //collectionView.scrollToItem(at: collectionView.currentIndexPath, at: .top, animated: true)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        reloadColumnNumber()
    }
    
    
    // MARK: Navbar Functions
    
    @IBAction func showMembers(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Team", bundle: nil).instantiateViewController(withIdentifier: "MemberNavViewController") as! UINavigationController
        if let root = vc.viewControllers.first as? MembersViewController {
            root.members = teamManager.users
            root.teamManager = teamManager
        }
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func showChat(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Team", bundle: nil).instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
        vc.chatManager = chatManager
        vc.members = teamManager.users
        vc.navigationItem.rightBarButtonItem = membersButton
        vc.navigationItem.title = "Chat"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    // MARK: Toolbar Functions
    
    var didZoomOut = false
    @IBAction func zoom(_ sender: UIBarButtonItem) {
        if didZoomOut {
            didZoomOut = false
            collectionView.isPagingEnabled = true
        } else {
            didZoomOut = true
            collectionView.isPagingEnabled = false
        }
        reloadView()
    }
    
    @IBAction func nextColumn(_ sender: UIBarButtonItem) {
        var indexPath = collectionView.currentIndexPath
        let numberOfItems = collectionView(collectionView, numberOfItemsInSection: TeamViewSection.tasks.rawValue)
        switch indexPath.section {
        case TeamViewSection.overView.rawValue:
            if numberOfItems > 0 {
                indexPath.section = TeamViewSection.tasks.rawValue
                indexPath.item = 0
            } else {
                indexPath.section = TeamViewSection.newSection.rawValue
                indexPath.item = 0
            }
        
        case TeamViewSection.tasks.rawValue:
            if indexPath.item != numberOfItems - 1 {
                indexPath.item = indexPath.item + 1
            } else {
                indexPath.section = TeamViewSection.newSection.rawValue
                indexPath.item = 0
            }
        case TeamViewSection.newSection.rawValue:
            indexPath.section = 0
            indexPath.item = 0
        default:
            print("Something wrong")
        }
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func pastColumn(_ sender: UIBarButtonItem) {
        var indexPath = collectionView.currentIndexPath
        
        switch indexPath.section {
        case TeamViewSection.overView.rawValue:
            indexPath.section = TeamViewSection.newSection.rawValue
            indexPath.item = 0
        case TeamViewSection.tasks.rawValue:
            if indexPath.item > 0 {
                indexPath.item = indexPath.item - 1
            } else {
                indexPath.section = TeamViewSection.overView.rawValue
                indexPath.item = 0
            }
        case TeamViewSection.newSection.rawValue:
            indexPath.section = TeamViewSection.tasks.rawValue
            indexPath.item = collectionView(collectionView, numberOfItemsInSection: TeamViewSection.tasks.rawValue) - 1
        default:
            print("Something wrong")
        }
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func goToOverview(_ sender: UIBarButtonItem) {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    func reloadView() {
        collectionView.reloadData()
        reloadColumnNumber()
    }
    
    func reloadColumnNumber() {
        let indexPath = collectionView.currentIndexPath
        
        switch indexPath.section {
        case TeamViewSection.overView.rawValue:
            columnNumberLabel.text = "Home"
        case TeamViewSection.tasks.rawValue:
            let numberOfItems = collectionView(collectionView, numberOfItemsInSection: TeamViewSection.tasks.rawValue)
            columnNumberLabel.text = "\(indexPath.item + 1) of \(numberOfItems)"
        case TeamViewSection.newSection.rawValue:
            columnNumberLabel.text = "New"
        default:
            print("Something wrong")
        }
    }
    
    func reloadTaskDetailIfNeeded() {
        if let vc = self.presentedViewController as? TaskDetailViewController {
            if teamModel?.sections.count ?? 0 > vc.sectionIndex?.item ?? 0 {
                if teamModel!.sections[vc.sectionIndex!.item].tasks?.count ?? 0 > vc.taskIndex?.row ?? 0 {
                    vc.taskModel = teamModel!.sections[vc.sectionIndex!.item].tasks![vc.taskIndex!.row]
                    vc.tableView.reloadData()
                } else {
                    vc.dismiss(animated: true, completion: nil)
                }
            } else {
                vc.dismiss(animated: true, completion: nil)
            }
        } else if let vc = self.presentedViewController as? SectionDetailViewController {
            if teamModel?.sections.count ?? 0 > vc.sectionIndex?.item ?? 0 {
                vc.sectionModel = teamModel?.sections[vc.sectionIndex!.item]
                vc.viewDidLoad()
            } else {
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: Chat Manager Delegate
    
    
    func didLoadMessages(_ chatManager: ChatManager, messages: [MessageModel]) {
        chatButton.isEnabled = true
    }
    
    
    // MARK: Team Manager Delegate
    
    func userKicked() {
        presentedViewController?.dismiss(animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: false)
    }
    
    func didLoadTeam(_ teamManager: TeamManager, team: TeamModel) {
        if chatManager == nil {
            chatManager = ChatManager()
            chatManager?.delegate = self
            chatManager?.teamID = team.id
            chatManager?.addSnapshotListener()
        }
        teamModel = team
        reloadView()
        reloadTaskDetailIfNeeded()
        teamManager.getMemebers(members: team.members)
    }
    
    func didLoadMembers(_ teamManager: TeamManager, members: [UserModel]) {
        membersButton.isEnabled = true
    }


    // MARK: UICollectionView

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == TeamViewSection.tasks.rawValue {
            return teamModel?.sections.count ?? 0
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
        
        switch indexPath.section {
        case TeamViewSection.overView.rawValue:
            let overViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "OverviewView", for: indexPath) as! OverviewView
            if let team = teamModel, let userID = Auth.auth().currentUser?.uid {
                let teamOverview = TeamOverviewModel(team: team, userID: userID)
                overViewCell.teamOverview = teamOverview
                overViewCell.teamManager = self.teamManager
            }
            overViewCell.tableView.reloadData()
            return overViewCell
        case TeamViewSection.tasks.rawValue:
            if let sect = teamModel?.sections[indexPath.item] {
                cell.sectionModel = sect
            }
        default:
            cell.sectionModel = SectionModel(title: "New section", tasks: [])
        }
        cell.sectionIndex = indexPath
        cell.delegate = teamManager
    
        return cell
    }

    
    // MARK: Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if didZoomOut {
            //let nos = 2 + self.collectionView(collectionView, numberOfItemsInSection: TeamViewSection.tasks.rawValue)
            return CGSize(width: view.frame.width * 0.75, height: collectionView.frame.height)
        } else {
            return CGSize(width: view.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dest = segue.destination as? ChatViewController, let members = teamManager.users {
            dest.members = members
            dest.chatManager = chatManager
        }
    }

}

extension UICollectionView {
    var currentIndexPath: IndexPath {
        let contentWidth = contentSize.width
        let numberOfPages = contentWidth / frame.width
        let currentPage = Int(numberOfPages * ((contentOffset.x + 1) / (contentWidth + 1)))
        
        let numberOfItems = self.numberOfItems(inSection: TeamViewSection.tasks.rawValue)
        
        var section = TeamViewSection.overView.rawValue
        var item = 0
        
        if currentPage > 0, currentPage <= numberOfItems {
            section = TeamViewSection.tasks.rawValue
            item = currentPage - 1
        } else if currentPage > numberOfItems {
            section = TeamViewSection.newSection.rawValue
            item = 0
        }
        
        return IndexPath(item: item, section: section)
    }
}
