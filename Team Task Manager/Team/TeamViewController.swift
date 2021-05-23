//
//  TeamViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 11.05.2021.
//

import UIKit
import SideMenu

struct TeamViewSection {
    var overView = -1
    var tasks = 0
    var newSection = 1
}

class TeamViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, TeamManagerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var columnNumberLabel: UILabel!
    @IBOutlet weak var membersButton: UIBarButtonItem!
    
    var teamID: String?
    lazy var teamManager = TeamManager(delegate: self)
    
    var teamModel: TeamModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(UINib(nibName: "SectionView", bundle: nil), forCellWithReuseIdentifier: "SectionView")
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
    
    // MARK: Toolbar Functions
    
    @IBAction func nextColumn(_ sender: UIBarButtonItem) {
        var indexPath = collectionView.currentIndexPath
        let numberOfItems = collectionView(collectionView, numberOfItemsInSection: 0)
        if indexPath.item != numberOfItems - 1 {
            indexPath.item = indexPath.item + 1
        } else {
            indexPath.section = 1
            indexPath.item = 0
        }
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    @IBAction func pastColumn(_ sender: UIBarButtonItem) {
        var indexPath = collectionView.currentIndexPath
        if indexPath.item > 0 {
            indexPath.item = indexPath.item - 1
        } else if indexPath.section == 1 {
            indexPath.section = 0
            indexPath.item = collectionView(collectionView, numberOfItemsInSection: 0) - 1
        }
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
    
    
    func reloadView() {
        collectionView.reloadData()
        reloadColumnNumber()
    }
    
    func reloadColumnNumber() {
        let indexPath = collectionView.currentIndexPath
        if indexPath.section == 0 {
            let numberOfItems = collectionView(collectionView, numberOfItemsInSection: 0)
            columnNumberLabel.text = "\(indexPath.item + 1) of \(numberOfItems)"
        } else {
            columnNumberLabel.text = "New"
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
    
    // MARK: Team Manager Delegate
    
    func didLoadTeam(_ teamManager: TeamManager, team: TeamModel) {
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
        return 2
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return teamModel?.sections.count ?? 0
        } else {
            return 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionView", for: indexPath) as! SectionView
        
        //let numberOfItems = self.collectionView(collectionView, numberOfItemsInSection: 0)
        
        if indexPath.section == 0, let sect = teamModel?.sections[indexPath.item] {
            cell.viewModel.sectionModel = SectionModel(title: "New section", tasks: [])
            cell.sectionModel = sect
        } else {
            cell.viewModel.sectionModel = SectionModel(title: "New section", tasks: [])
            cell.sectionModel = SectionModel(title: "New section", tasks: [])
        }
        cell.viewModel.sectionIndex = indexPath
        cell.sectionIndex = indexPath
        cell.delegate = teamManager
    
        return cell
    }

    
    // MARK: Layout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

}

extension UICollectionView {
    var currentIndexPath: IndexPath {
        let contentWidth = contentSize.width
        let numberOfPages = contentWidth / frame.width
        var currentPage = Int(numberOfPages * ((contentOffset.x + 1) / (contentWidth + 1)))
        
        let numberOfItems = self.numberOfItems(inSection: 0)
        
        var section = 0
        if currentPage == numberOfItems {
            section = 1
            currentPage = 0
        }
        
        return IndexPath(item: currentPage, section: section)
    }
}
