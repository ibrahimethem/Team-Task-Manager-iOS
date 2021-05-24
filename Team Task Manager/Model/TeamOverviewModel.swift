//
//  TeamOverviewModel.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 24.05.2021.
//

import Foundation

struct TeamOverviewModel {
    var teamName: String
    var teamDescription: String
    var newMessages: Int
    var newTasks: Int
    
    init(team: TeamModel, userID: String) {
        self.teamName = team.teamName
        self.teamDescription = team.teamDescription
        self.newMessages = 0
        
        var tasks = [TaskModel]()
        for section in team.sections {
            if let lastDate = team.membersInfo.first(where: { $0.userID == userID})?.joinDate, let filteredTasks = section.tasks?.filter({ $0.creationDate.dateValue() > lastDate.dateValue()}) {
                tasks.append(contentsOf: filteredTasks)
            }
        }
        newTasks = tasks.count
    }
}
