//
//  SettingsViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import UIKit

protocol SettingsPresenterDelegate {
    func didDismissSettings()
}

class SettingsViewController: UITableViewController {
    private let viewModel = SettingsViewModel()

    public var delegate: SettingsPresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Paramètres"

        tableView.register(UINib(nibName: ToggleCell.identifier, bundle: nil), forCellReuseIdentifier: ToggleCell.identifier)
        tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        tableView.register(UINib(nibName: UserCell.identifier, bundle: nil), forCellReuseIdentifier: UserCell.identifier)
        tableView.register(UINib(nibName: OptionCell.identifier, bundle: nil), forCellReuseIdentifier: OptionCell.identifier)

        configureNavigationBar()
    }

    override func viewDidDisappear(_ animated: Bool) {
        delegate?.didDismissSettings()
    }

    static func instantiateInNavigationController(delegate: SettingsPresenterDelegate?) -> UINavigationController {
        let viewController = SettingsViewController(style: .insetGrouped)
        viewController.delegate = delegate
        return UINavigationController(rootViewController: viewController)
    }

    private func configureNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func getAccountCell(for indexPath: IndexPath) -> UITableViewCell {
        if let user = viewModel.planningManager.user {
            let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as! UserCell
            cell.configure(with: user)
            return cell
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
        cell.configure(with: .account)
        return cell
    }

    private func getAboutCell(for indexPath: IndexPath) -> UITableViewCell {
        let row = viewModel.settings[indexPath.section].items[indexPath.row]
        switch row {
        case .homeworkAlerts:
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
            cell.configure(with: row, value: "1 jour avant")
            return cell
        case .campusSport:
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.identifier, for: indexPath) as! ToggleCell
            cell.configure(with: row, defaultValue: UserDefaults.standard.bool(forKey: "campusSport")) { value in
                UserDefaults.standard.set(value, forKey: "campusSport")
            }
            return cell
        case .visibility:
            let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
            cell.configure(with: row, value: "60 jours")
            return cell
        default:
            fatalError("Unhandled item")
        }
    }

    private func didTapConnectionCell() {
        let alertVC = UIAlertController(title: "Se connecter", message: nil, preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = "Identifiant"
        }
        alertVC.addTextField { textField in
            textField.placeholder = "Mot de passe"
            textField.isSecureTextEntry = true
        }
        alertVC.addAction(UIAlertAction(title: "Valider", style: .default) { [weak self] _ in
            guard let self = self,
                  let login = alertVC.textFields?[0].text, let password = alertVC.textFields?[1].text else { return }
            Task {
                do {
                    try await self.viewModel.connectUser(login: login, password: password)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                } catch {
                    print("Error while connecting user")
                }
            }
        })
        alertVC.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        present(alertVC, animated: true)
    }

    private func didTapDisconnectionCell() {
        let alertVC = UIAlertController(title: "Mon compte",
                                        message: "Voulez-vous vraiment vous déconnecter ?",
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Se déconnecter", style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.viewModel.disconnectUser()
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            } catch {
                print("Error while disconnecting user")
            }
        })
        alertVC.addAction(UIAlertAction(title: "Annuler", style: .cancel))
        present(alertVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension SettingsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.settings.count
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
            return getAccountCell(for: indexPath)
        case .plannings:
            let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
            cell.configure(with: .plannings)
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
            if viewModel.isUserConnected {
                didTapDisconnectionCell()
            } else {
                didTapConnectionCell()
            }
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
