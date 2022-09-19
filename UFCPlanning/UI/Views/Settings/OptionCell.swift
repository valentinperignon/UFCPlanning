//
//  OptionCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 17/09/2022.
//

import UIKit

class OptionCell: UITableViewCell {
    static let identifier = "OptionCell"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var value: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with item: SettingsRow, value: String) {
        label.text = item.name
        self.value.text = value
    }
}
