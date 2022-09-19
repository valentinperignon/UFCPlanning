//
//  GroupsViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 19/09/2022.
//

import UIKit

class GroupsViewController: UITableViewController {
    var viewModel: GroupsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.parent.name

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        Task {
            try? await viewModel.fetchGroups()
            tableView.reloadData()
        }
    }

    static func instantiateInNavigationController() -> UINavigationController {
        let viewController = GroupsViewController()
        viewController.viewModel = GroupsViewModel()
        return UINavigationController(rootViewController: viewController)
    }
}

// MARK: - TableViewDataSource

extension GroupsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = viewModel.groups[indexPath.row].name
        cell.contentConfiguration = content
        return cell
    }
}

// MARK: - TableViewDelegate

extension GroupsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let group = viewModel.groups[indexPath.row]

        if group.type == .final {
            viewModel.planningManager.save(group: group)
            dismiss(animated: true)
        } else {
            let viewController = GroupsViewController()
            viewController.viewModel = GroupsViewModel(parent: group)
            show(viewController, sender: self)
        }
    }
}
