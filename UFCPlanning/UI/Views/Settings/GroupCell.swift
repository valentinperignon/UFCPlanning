//
//  GroupCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 17/09/2022.
//

import UIKit

class GroupCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    @IBAction func didTapHideButton(_ sender: Any) {
    }

    @IBAction func didTapDeleteButton(_ sender: Any) {
    }
}
