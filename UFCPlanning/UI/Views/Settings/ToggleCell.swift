//
//  ToggleCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 13/09/2022.
//

import UIKit

class ToggleCell: UITableViewCell {
    static let identifier = "ToggleCell"

    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var switchButton: UISwitch!

    var toggleHandler: ((Bool) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func configure(with item: SettingsRow, defaultValue: Bool, toggleHandler: @escaping (Bool) -> Void) {
        label.text = item.name
        switchButton.setOn(defaultValue, animated: false)
        self.toggleHandler = toggleHandler
    }

    @IBAction func toggleSwitch(_ sender: UISwitch) {
        toggleHandler?(sender.isOn)
    }
}
