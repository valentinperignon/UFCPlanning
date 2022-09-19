//
//  GroupCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 17/09/2022.
//

import SFSafeSymbols
import UFCPlanningCore
import UIKit

class GroupCell: UITableViewCell {
    static let identifier = "GroupCell"

    var hideGroup: (() -> Void)?
    var deleteGroup: (() -> Void)?

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var visibilityButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(with group: Group) {
        label.text = group.name
        if group.isVisible {
            visibilityButton.setImage(.eye, for: .normal)
        } else {
            visibilityButton.setImage(.eyeSlash, for: .normal)
        }
    }

    @IBAction func didTapHideButton(_ sender: Any) {
        hideGroup?()
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
        deleteGroup?()
    }
}
