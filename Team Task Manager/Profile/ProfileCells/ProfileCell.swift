//
//  ProfileCell.swift
//  Team Task Manager
//
//  Created by İbrahim Ethem Karalı on 17.04.2021.
//

import UIKit

class ProfileCell: UITableViewCell {

    /// row number of the cell
    var index: Int?
    var key: UserModel.codingKeys?
    var delegate: ProfileCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

protocol ProfileCellDelegate {
    func infoDidChange(_ cell: ProfileCell, info: String)
}
