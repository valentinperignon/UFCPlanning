//
//  SubjectCell.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 05/09/2022.
//

import UFCPlanningCore
import UIKit

class SubjectCell: UITableViewCell {
    static let identifier = "SubjectCell"

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var about: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var border: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(with subject: Lesson) {
        contentView.backgroundColor = subject.color.withAlphaComponent(0.05)
        border.backgroundColor = subject.color
        
        name.text = subject.name
        about.text = subject.about
        time.text = "\(subject.formattedStart) - \(subject.formattedEnd)"
    }
}
