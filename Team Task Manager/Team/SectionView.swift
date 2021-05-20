//
//  SectionView.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 12.05.2021.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class SectionView: UICollectionViewCell, UITableViewDelegate, UITableViewDataSource, NewTaskCellDelegate, SectionHeaderDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var isAdding = false
    
    var sectionIndex: IndexPath?
    
    var sectionModel: SectionModel? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var header: TeamSectionHeaderView?
    
    struct ViewModel {
        var sectionModel: SectionModel?
        var sectionIndex: IndexPath?
    }
    
    lazy var viewModel = ViewModel()
    
    var delegate: SectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "TaskCell", bundle: nil), forCellReuseIdentifier: "TaskCell")
        tableView.register(UINib(nibName: "AddTaskCell", bundle: nil), forCellReuseIdentifier: "AddTaskCell")
        tableView.register(UINib(nibName: "NewTaskCell", bundle: nil), forCellReuseIdentifier: "NewTaskCell")
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return sectionModel?.tasks?.count ?? 0
        case 1:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
            
            cell.taskModel = sectionModel?.tasks?[indexPath.row]
            
            return cell
        default:
            if isAdding {
                let cell = tableView.dequeueReusableCell(withIdentifier: "NewTaskCell", for: indexPath) as! NewTaskCell
                cell.delegateTable = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "AddTaskCell", for: indexPath) as! AddTaskCell
                
                return cell
            }
        }
    }
    
    // MARK: Table Header Functions
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            header = TeamSectionHeaderView()
            header?.delegate = self
            switch sectionIndex?.section {
            case 0:
                header?.textField.text = sectionModel?.title
                header?.textField.isUserInteractionEnabled = false
                return header
            case 1:
                header?.moreButton.isHidden = true
                return header
            default:
                return nil
            }
        } else {
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 44
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if let task = sectionModel?.tasks?[indexPath.row] {
                delegate?.selectTask(self, task: task, taskIndex: indexPath)
            } else {
                print("Unable to select")
            }
        } else {
            if !isAdding {
                isAdding = !isAdding
                tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .fade)
            }
        }
    }
    
    // MARK: Section Header Delegate Function
    
    func moreButtonPressed(_ teamSectionHeaderView: TeamSectionHeaderView) {
        delegate?.editSection(self, section: sectionModel!)
    }
    
    // MARK: New Task Delegate Functions
    
    func didAddNewTask(title: String, details: String) {
        let userID = Auth.auth().currentUser?.uid
        let taskModel = TaskModel(creationDate: Timestamp(), creator: userID, details: details, title: title)
        isAdding = false
        if sectionIndex?.section == 0 {
            delegate?.addTask(self, task: taskModel)
        } else if sectionIndex?.section == 1 {
            let sectionHeader = header?.textField.text ?? "New section"
            let sm = SectionModel(title: sectionHeader, tasks: [taskModel])
            delegate?.addNewSection(self, section: sm)
        }
    }
    
    func didCancelNewTask() {
        isAdding = false
        tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .fade)
    }
    
    
    
}

protocol SectionViewDelegate {
    func addNewSection(_ sectionView: SectionView, section: SectionModel)
    func editSection(_ sectionView: SectionView, section: SectionModel)
    func addTask(_ sectionView: SectionView, task: TaskModel)
    func selectTask(_ sectionView: SectionView, task: TaskModel, taskIndex: IndexPath)
}
