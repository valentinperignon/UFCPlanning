//
//  UserCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 15/09/2022.
//

import UFCPlanningCore
import UIKit

class UserCell: UITableViewCell {
    static let identifier = "UserCell"

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var studentId: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with user: User) {
        name.text = user.name.capitalized
        studentId.text = user.id
    }
}
