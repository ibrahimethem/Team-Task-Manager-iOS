//
//  TaskDetailViewController.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 20.05.2021.
//

import UIKit

class TaskDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, AddCommentDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var taskModel: TaskModel?
    var taskIndex: IndexPath?
    var sectionIndex: IndexPath?
    var presentingVC: TeamViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        case 3:
            return (taskModel?.comments?.count ?? 0)
        default:
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailInfoCell", for: indexPath) as! TaskDetailInfoCell
            cell.titleTextField.text = taskModel?.title
            cell.detailsTextView.text = taskModel?.details
            
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            formatter.doesRelativeDateFormatting = true
            
            let date = taskModel?.creationDate.dateValue()
            
            cell.creationDate.text = "on \(formatter.string(from: date!))"
            if let creatorName = presentingVC?.teamManager.users?.first(where: { $0.id == taskModel?.creator })?.profileName {
                cell.creatorLabel.text = "Created by \(creatorName)"
            } else {
                cell.creatorLabel.text = "Created by unknown user"
            }
            
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailComplateCell", for: indexPath)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TaskDetailRemoveCell", for: indexPath)
                return cell
            }
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentCell", for: indexPath) as! AddCommentCell
            cell.delegate = self
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCommentCell", for: indexPath) as! TaskCommentCell
            if let comment = taskModel?.comments?[indexPath.row] {
                if let creatorName = presentingVC?.teamManager.users?.first(where: { $0.id == comment.userID })?.profileName {
                    cell.userNameLabel.text = "by \(creatorName)"
                } else {
                    cell.userNameLabel.text = "by Anonymus"
                }
                cell.commentTextView.text = comment.comment
                
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                formatter.doesRelativeDateFormatting = true
                
                let date = comment.date.dateValue()
                
                cell.userNameLabel.text = "\(cell.userNameLabel.text!) on \(formatter.string(from: date))"
            }
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    @IBAction func done(_ sender: UIBarButtonItem) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? TaskDetailInfoCell else { return }
        taskModel?.title = cell.titleTextField.text
        taskModel?.details = cell.detailsTextView.text
        guard let vc = presentingVC else { return }
        if sectionIndex != nil, taskIndex != nil, taskModel != nil {
            vc.teamManager.updateTask(sectionIndex: sectionIndex!, taskIndex: taskIndex!, task: taskModel!)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func addComment(with text: String) {
        guard let vc = presentingVC else { return }
        if sectionIndex != nil, taskIndex != nil {
            vc.teamManager.addComment(with: text, sectionIndex: sectionIndex!, taskIndex: taskIndex!)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1, indexPath.row == 1 {
            if let vc = presentingVC, sectionIndex != nil, taskIndex != nil {
                vc.teamManager.removeTask(sectionIndex: sectionIndex!, taskIndex: taskIndex!)
                dismiss(animated: true, completion: nil)
            }
        }
    }
    
}
