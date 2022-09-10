//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

import EventKitUI
import RealmSwift
import UFCPlanningCore
import UIKit

class HomeViewController: UITableViewController {
    private var viewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "UFC Planning"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.register(UINib(nibName: "SubjectCell", bundle: nil), forCellReuseIdentifier: "SubjectCell")
        tableView.allowsSelection = false

        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(viewModel, action: #selector(viewModel.refreshPlanning), for: .valueChanged)
    }
}

// MARK: - UITableViewDataSource

extension HomeViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.planning.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = viewModel.planning[section]
        return day.date.formatted(.dateTime.day().month(.wide))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = viewModel.planning[section]
        return viewModel.planning[section].subjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell
        cell.configure(with: viewModel.getSubject(at: indexPath))

        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Add to calendar") { [weak self] _, _, completion in
            guard let self = self else { return }
            let subject = self.viewModel.getSubject(at: indexPath).freeze()
            self.viewModel.addHomework(for: subject, delegate: self, completion: completion) { viewController in
                self.present(viewController, animated: true)
            }
        }
        action.backgroundColor = .orange
        action.image = UIImage(systemName: "calendar.badge.plus")

        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - EKEventEditViewDelegate

extension HomeViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true)
    }
}
