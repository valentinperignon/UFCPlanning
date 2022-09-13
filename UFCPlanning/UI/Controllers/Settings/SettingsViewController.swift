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

        tableView.register(UINib(nibName: ToggleCell.identifier, bundle: nil), forCellReuseIdentifier: ToggleCell.identifier)

        configureNavigationBar()
    }

    static func instantiateInNavigationController() -> UINavigationController {
        return UINavigationController(rootViewController: SettingsViewController(style: .insetGrouped))
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func getAboutCell(for indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.settings[indexPath.section].items[indexPath.row]
        switch row {
        case .homeworkAlerts:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Campus"
            return cell
        case .campusSport:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.identifier, for: indexPath) as! ToggleCell
            cell.configure(with: row, defaultValue: UserDefaults.standard.bool(forKey: "campusSport")) { value in
                UserDefaults.standard.set(value, forKey: "campusSport")
            }
            return cell
        case .visibility:
            let cell = UITableViewCell()
            cell.textLabel?.text = "Visibilité"
            return cell
        default:
            fatalError("Unhandled item")
        }
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
            return getAboutCell(for: indexPath)
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
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
