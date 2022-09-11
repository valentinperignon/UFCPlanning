//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

import EventKitUI
import RealmSwift
import SFSafeSymbols
import UFCPlanningCore
import UIKit

class HomeViewController: UITableViewController {
    private let viewModel = HomeViewModel()
    private let eventStore = EKEventStore()

    private var searchController: UISearchController!

    private var isSearchBarEmpty: Bool {
        searchController.searchBar.text?.isEmpty ?? true
    }
    private var isFiltering: Bool {
        searchController.isActive && !isSearchBarEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: SubjectCell.identifier, bundle: nil), forCellReuseIdentifier: SubjectCell.identifier)
        tableView.allowsSelection = false

        configureNavigationBar()
        configureSearchBar()
        configureRefreshControl()
        bindViewModel()
    }

    private func configureNavigationBar() {
        navigationItem.title = "UFC Planning"
        navigationController?.navigationBar.prefersLargeTitles = true

        let settingsButton = UIBarButtonItem(
            image: UIImage(systemSymbol: SFSymbol.ellipsis),
            style: .plain,
            target: self,
            action: #selector(presentSettingsViewController)
        )
        navigationItem.rightBarButtonItem = settingsButton
    }

    private func configureSearchBar() {
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Rechercher des cours"
        navigationItem.searchController = searchController
        definesPresentationContext = true
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
        // TODO: Display settings
    }

    private func addHomeworkToCalendar(for subject: Lesson, completion: @escaping (Bool) -> Void) {
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
        if isFiltering {
            return viewModel.filteredPlanning.count
        }
        return viewModel.planning.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let day = viewModel.getDay(at: section, filtered: isFiltering)
        return day.date.formatted(.dateTime.day().month(.wide))
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let day = viewModel.getDay(at: section, filtered: isFiltering)
        return day.lessons.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SubjectCell.identifier, for: indexPath) as! SubjectCell
        cell.configure(with: viewModel.getLesson(at: indexPath, filtered: isFiltering))

        return cell
    }
}

// MARK: - UITableViewDelegate

extension HomeViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .normal, title: "Ajouter au calendrier") { [weak self] _, _, completion in
            guard let self = self else { return }
            let subject = self.viewModel.getLesson(at: indexPath, filtered: self.isFiltering).freeze()
            self.addHomeworkToCalendar(for: subject, completion: completion)
        }
        action.backgroundColor = .orange
        action.image = UIImage(systemSymbol: SFSymbol.calendarBadgePlus)

        return UISwipeActionsConfiguration(actions: [action])
    }
}

// MARK: - EKEventEditViewDelegate

extension HomeViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        dismiss(animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        tableView.reloadData()
    }
}
