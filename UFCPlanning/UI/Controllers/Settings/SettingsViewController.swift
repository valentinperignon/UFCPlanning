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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.settings[section] == SettingsSection.plannings {
            return 1
        }
        return viewModel.settings[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.settings[indexPath.section]
        switch section {
        case .account:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Aucun compte connecté"
            return cell
        case .plannings:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Ajouter un planning"
            return cell
        case .about:
            let item = section.items[indexPath.row]
            let cell = UITableViewCell()
            cell.textLabel?.text = item.name
            return cell
        default:
            fatalError("Unhandled section")
        }
    }
}

// MARK: - UITableViewDelegate

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = viewModel.settings[indexPath.section]
        switch section {
        case .account:
            let alertVC = UIAlertController(title: "Se connecter", message: nil, preferredStyle: .alert)
            alertVC.addTextField { textField in
                textField.placeholder = "Identifiant"
            }
            alertVC.addTextField { textField in
                textField.placeholder = "Mot de passe"
                textField.isSecureTextEntry = true
            }
            alertVC.addAction(UIAlertAction(title: "Valider", style: .default))
            alertVC.addAction(UIAlertAction(title: "Annuler", style: .cancel))
            present(alertVC, animated: true)
        default:
            fatalError("Unhandled section") 
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
