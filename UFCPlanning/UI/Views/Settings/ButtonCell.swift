//
//  ButtonCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 15/09/2022.
//

import UIKit

class ButtonCell: UITableViewCell {
    static let identifier = "ButtonCell"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var icon: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configure(with item: SettingsItem) {
        icon.image = UIImage(systemSymbol: item.icon)
        label.text = item.name
    }
}
