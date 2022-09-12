//
//  SettingsViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import UIKit

class SettingsViewController: UITableViewController {
    private let viewModel = SettingsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Paramètres"

        configureNavigationBar()
    }

    static func instantiateInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: SettingsViewController(style: .insetGrouped))
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.settings[section].name
    }
}
