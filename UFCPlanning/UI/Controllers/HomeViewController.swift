//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

import RealmSwift
import UFCPlanningCore
import UIKit

class HomeViewController: UITableViewController {
    private var planningManager: PlanningManager!
    
    private var observationToken: NotificationToken?
    
    private var planning = AnyRealmCollection(List<Day>())
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "UFC Planning"
        
        planningManager = PlanningManager()
        observeDays()
        
        Task {
            await fetchPlanning()
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return planning.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = planning[section]
        return day.date.formatted(.dateTime.day().month(.wide))
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = planning[section]
        return day.subjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let day = planning[indexPath.section]
        let subject = day.subjects[indexPath.row]
        
        let cell = UITableViewCell()
        cell.textLabel?.text = "\(subject.name) : \(subject.start.formatted(.dateTime.hour().minute()))"
        return cell
    }
    
    private func observeDays() {
        let realm = planningManager.getRealm()
        planning = AnyRealmCollection(realm.objects(Day.self))
        observationToken = planning.observe { [weak self] changes in
            guard let self = self else { return }
            switch changes {
            case let .initial(days):
                self.planning = days
                self.tableView.reloadData()
            case let .update(days, deletions: deletions, insertions: insertions, modifications: modifications):
                self.planning = days
                self.tableView.reloadData()
                // TODO: Update with batch action
            case let .error(error):
                print("Error: \(error.localizedDescription)")
            }
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
