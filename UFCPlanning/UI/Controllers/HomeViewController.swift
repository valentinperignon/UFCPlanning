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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        planningManager = PlanningManager()
        
        Task {
            await fetchPlanning()
        }
    }
    
    private func fetchPlanning() async {
        do {
            try await planningManager.planning()
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
