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
    private var eventStore = EKEventStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: SubjectCell.identifier, bundle: nil), forCellReuseIdentifier: SubjectCell.identifier)
        tableView.allowsSelection = false

        configureNavigationBar()
        configureRefreshControl()
        bindViewModel()
    }

    private func configureNavigationBar() {
        navigationItem.title = "UFC Planning"
        navigationController?.navigationBar.prefersLargeTitles = true

        let settingsButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(presentSettingsViewController)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }
    
    private func configureRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(viewModel, action: #selector(viewModel.refreshPlanning), for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel.onListUpdate = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.endRefreshingList = { [weak self] in
            self?.refreshControl?.endRefreshing()
        }
    }

    @objc private func presentSettingsViewController() {
        print("Hello!")
    }

    private func addHomeworkToCalendar(for subject: Subject, completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            guard let self = self, error == nil && granted else {
                completion(false)
                return
            }

            let event = EKEvent(eventStore: self.eventStore)
            event.title = "[\(subject.name)] "
            event.startDate = subject.start
            event.endDate = subject.end
            event.alarms = [EKAlarm(relativeOffset: EventAlarm.dayBefore.rawValue)]

            DispatchQueue.main.async {
                let eventVC = EKEventEditViewController()
                eventVC.editViewDelegate = self
                eventVC.eventStore = self.eventStore
                eventVC.event = event

                self.present(eventVC, animated: true)
                completion(true)
            }
        }
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
        return day.subjects.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectCell.identifier, for: indexPath) as! SubjectCell
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
            self.addHomeworkToCalendar(for: subject, completion: completion)
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
