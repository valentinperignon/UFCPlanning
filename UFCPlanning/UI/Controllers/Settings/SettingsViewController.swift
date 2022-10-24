//
//  SettingsViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 12/09/2022.
//

import UFCPlanningCore
import UIKit

protocol SettingsPresenterDelegate {
    func didDismissSettings()
}

class SettingsViewController: UITableViewController {
    private let viewModel = SettingsViewModel()

    public var delegate: SettingsPresenterDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = L10n.Localizable.Settings.title

        tableView.register(UINib(nibName: UserCell.identifier, bundle: nil), forCellReuseIdentifier: UserCell.identifier)
        tableView.register(UINib(nibName: GroupCell.identifier, bundle: nil), forCellReuseIdentifier: GroupCell.identifier)
        tableView.register(UINib(nibName: ButtonCell.identifier, bundle: nil), forCellReuseIdentifier: ButtonCell.identifier)
        tableView.register(UINib(nibName: ToggleCell.identifier, bundle: nil), forCellReuseIdentifier: ToggleCell.identifier)
        tableView.register(UINib(nibName: OptionCell.identifier, bundle: nil), forCellReuseIdentifier: OptionCell.identifier)

        bindViewModel()
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

    private func bindViewModel() {
        viewModel.updateList = { [weak self] deletions, insertions, modifications, shouldReload in
            guard let self else { return }
            if shouldReload {
                self.tableView.reloadSections(IndexSet(integer: 1), with: .automatic)
            } else {
                self.tableView.performBatchUpdates {
                    self.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 1) }, with: .automatic)
                    self.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 1) }, with: .automatic)
                    self.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 1) }, with: .automatic)
                }
            }
        }
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
        guard let userDefaultsKey = row.userDefaultsKey else { fatalError("No UserDefaults key provided") }

        if row == .campusSport {
            let cell = tableView.dequeueReusableCell(withIdentifier: ToggleCell.identifier, for: indexPath) as! ToggleCell
            cell.configure(with: row, defaultValue: UserDefaults.standard.bool(forKey: userDefaultsKey)) { value in
                UserDefaults.standard.set(value, forKey: userDefaultsKey)
            }
            return cell
        }

        var value: any SettingsEnum
        if row == .homeworkAlerts {
            value = EventAlarm(rawValue: UserDefaults.standard.double(forKey: userDefaultsKey)) ?? EventAlarm.defaultValue
        } else {
            value = VisibilityDays(rawValue: UserDefaults.standard.integer(forKey: userDefaultsKey)) ?? VisibilityDays.defaultValue
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
        cell.configure(with: row, value: value.description)
        return cell
    }

    private func didTapConnectionCell() {
        let alertVC = UIAlertController(title: L10n.Localizable.Settings.Login.title, message: nil, preferredStyle: .alert)
        alertVC.addTextField { textField in
            textField.placeholder = L10n.Localizable.Settings.Login.login
        }
        alertVC.addTextField { textField in
            textField.placeholder = L10n.Localizable.Settings.Login.password
            textField.isSecureTextEntry = true
        }
        alertVC.addAction(UIAlertAction(title: L10n.Localizable.Action.Button.confirm, style: .default) { [weak self] _ in
            guard let self,
                  let login = alertVC.textFields?[0].text, let password = alertVC.textFields?[1].text else { return }
            Task {
                do {
                    try await self.viewModel.connectUser(login: login, password: password)
                    self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
                } catch ApiError.wrongLoginOrPassword {
                    let errorVC = UIAlertController(
                        title: L10n.Localizable.Settings.Login.Error.title,
                        message: L10n.Localizable.Settings.Login.Error.message,
                        preferredStyle: .alert
                    )
                    errorVC.addAction(UIAlertAction(title: L10n.Localizable.Action.Button.ok, style: .default))
                    self.present(errorVC, animated: true)
                } catch {
                    print("Error while logging in user: \(error.localizedDescription)")
                }
            }
        })
        alertVC.addAction(UIAlertAction(title: L10n.Localizable.Action.Button.cancel, style: .cancel))
        present(alertVC, animated: true)
    }

    private func didTapDisconnectionCell() {
        let alertVC = UIAlertController(title: L10n.Localizable.Settings.Account.title,
                                        message: L10n.Localizable.Settings.Account.message,
                                        preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: L10n.Localizable.Settings.Account.button, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            do {
                try self.viewModel.disconnectUser()
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            } catch {
                print("Error while disconnecting user")
            }
        })
        alertVC.addAction(UIAlertAction(title: L10n.Localizable.Action.Button.cancel, style: .cancel))
        present(alertVC, animated: true)
    }

    private func didTap(option: SettingsRow) {
        let alertVC = UIAlertController(title: option.name, message: nil, preferredStyle: .actionSheet)
        alertVC.addAction(UIAlertAction(title: L10n.Localizable.Action.Button.cancel, style: .cancel))

        let availableOptions: [any SettingsEnum] = option == .visibility ? VisibilityDays.allCases : EventAlarm.allCases
        for option in availableOptions {
            alertVC.addAction(UIAlertAction(title: option.description, style: .default) { [weak self] _ in
                guard let self else { return }
                if let eventOption = option as? EventAlarm {
                    UserDefaults.standard.set(eventOption.rawValue, forKey: "homeworkAlert")
                } else if let visibilityOption = option as? VisibilityDays {
                    UserDefaults.standard.set(visibilityOption.rawValue, forKey: "daysNumber")
                }
                self.tableView.reloadSections(IndexSet(integer: 2), with: .automatic)
            })
        }

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
            return viewModel.groups.count + 1
        }
        return viewModel.settings[section].items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.settings[indexPath.section]
        switch section {
        case .account:
            return getAccountCell(for: indexPath)
        case .plannings:
            if indexPath.row == viewModel.groups.count {
                let cell = tableView.dequeueReusableCell(withIdentifier: ButtonCell.identifier, for: indexPath) as! ButtonCell
                cell.configure(with: .plannings)
                return cell
            }
            let group = viewModel.groups[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: GroupCell.identifier, for: indexPath) as! GroupCell
            cell.configure(with: group)
            cell.hideGroup = { [weak self] in
                self?.viewModel.planningManager.toggleVisibility(of: group)
            }
            cell.deleteGroup = { [weak self] in
                self?.viewModel.planningManager.delete(group: group)
            }
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
        case .about:
            let option = section.items[indexPath.row]
            guard option != .campusSport else { return }
            didTap(option: option)
        case .plannings:
            if indexPath.row == viewModel.groups.count {
                let groupsViewController = GroupsViewController.instantiateInNavigationController()
                present(groupsViewController, animated: true)
            }
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }
}
