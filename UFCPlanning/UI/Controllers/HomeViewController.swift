//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

import UFCPlanningCore
import UIKit

class HomeViewController: UITableViewController {
    var planningManager: PlanningManager!
    
    var plannings = [Planning]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planningManager = PlanningManager()
    }
}
