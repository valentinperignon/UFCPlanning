//
//  HomeViewController.swift
//  UFCPlanning
//
//  Created by Valentin Perignon on 20/08/2022.
//

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

        configureRefreshControl()
    }
    
    private func configureRefreshControl() {
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(viewModel, action: #selector(viewModel.refreshPlanning), for: .valueChanged)
    }

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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubjectCell", for: indexPath) as! SubjectCell

        let day = viewModel.planning[indexPath.section]
        let subject = day.subjects[indexPath.row]
        cell.configure(with: subject)

        return cell
    }
}
