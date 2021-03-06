//
//  HiveListViewController.swift
//  NectarTest
//
//  Created by Amadou Balde on 2021-05-18.
//

import UIKit

protocol HiveListViewControllerProtocol: class {
    func displayLoading(shown: Bool)
    func show(hives: [Hive])
}

class HiveListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private lazy var interactor: HiveListInteractorProtocol = {
        HiveListInteractor(viewController: self)
    }()
    
    private var hives: [Hive] = []
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("HiveList.Title", comment: "")
        
        // Set an empty footer so we don't have the ugly separator lines
        self.tableView.tableFooterView = UIView()
        // Estimate row height so we get accurate bar scrolling
        self.tableView.estimatedRowHeight = 140
        // Add a refresh control for swipe to refresh
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh(_:)), for: .valueChanged)
        self.tableView.refreshControl = refreshControl
        
        // Register cells
        // TODO: Registering and dequeuing may be moved to an extension so we can register solely on type
        self.tableView.register(UINib(nibName: HiveListTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: HiveListTableViewCell.nibName())
        
        self.interactor.onViewDidLoad()
    }
    
    @objc private func onRefresh(_ sender: UIRefreshControl) {
        self.interactor.onRefresh {
            sender.endRefreshing()
        }
    }
}

extension HiveListViewController: HiveListViewControllerProtocol {
    func displayLoading(shown: Bool) {
        self.activityIndicator.isHidden = !shown
        if shown {
            self.activityIndicator.startAnimating()
        }
    }
    
    func show(hives: [Hive]) {
        self.hives = hives
        self.tableView.reloadData()
    }
}

extension HiveListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.hives.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: This can be made generic so we can dequeue them with solely the type
        guard let cell = tableView
                .dequeueReusableCell(withIdentifier: HiveListTableViewCell.nibName(), for: indexPath) as? HiveListTableViewCell else {
            preconditionFailure("Attempted to dequeue cell of unknown type")
        }
        cell.configure(hive: hives[indexPath.row])
        return cell
    }
}

extension HiveListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        // Open the details view when the row has been selected
        let hive = self.hives[indexPath.row]
        let viewController = HiveDetailsViewController(hive: hive)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Label.Delete", comment: "")) {  (contextualAction, view, completion) in
            // When the user presses delete, send a delete command and refresh the row once we have success
            let hive = self.hives[indexPath.row]
            let cell = tableView.cellForRow(at: indexPath) as? HiveListTableViewCell
            cell?.updateLoading(shown: true)
            self.interactor.onTapDelete(id: hive.id) {
                self.hives.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
                completion(true)
            } onError: {
                cell?.updateLoading(shown: false)
                completion(false)
            }

            completion(true)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
        
        return swipeActions
    }
}
