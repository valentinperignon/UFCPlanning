//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

import RealmSwift
import UFCPlanningCore
import UIKit

class HomeViewController: UIViewController {
    private var planningManager: PlanningManager!
    
    private var observationToken: NotificationToken?
    private var planning = AnyRealmCollection(List<Day>())
    
    private var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "UFC Planning"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setUpTableView()
        tableView.register(UINib(nibName: "SubjectCell", bundle: nil), forCellReuseIdentifier: "SubjectCell")
        
        planningManager = PlanningManager()
        observeDays()
        
        configureRefreshControl()
        
        Task {
            await fetchPlanning()
        }
    }
    
    private func setUpTableView() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.allowsSelection = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
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
            case let .update(days, _, _, _):
                self.planning = days
                self.tableView.reloadData()
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
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshPlanning), for: .valueChanged)
    }
    
    @objc private func refreshPlanning() {
        Task {
            await fetchPlanning()
            tableView.refreshControl?.endRefreshing()
        }
    }
}

extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return planning.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = planning[section]
        return day.date.formatted(.dateTime.day().month(.wide))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = planning[section]
        return day.subjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        
        let day = planning[indexPath.section]
        let subject = day.subjects[indexPath.row]
        cell.configure(with: subject)
        
        return cell
    }
}
