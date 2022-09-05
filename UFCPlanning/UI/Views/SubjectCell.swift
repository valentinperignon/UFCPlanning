//
//  SubjectCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 05/09/2022.
//

import UFCPlanningCore
import UIKit

class SubjectCell: UITableViewCell {
    @IBOutlet weak var color: UIView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with subject: Subject) {
        color.backgroundColor = subject.color
        name.text = subject.name
        about.text = subject.about
    }
}
