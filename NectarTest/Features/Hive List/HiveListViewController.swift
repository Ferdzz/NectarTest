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
        self.tableView.estimatedRowHeight = 140
        
        // Register cells
        // TODO: Registering and dequeuing may be moved to an extension so we can register solely on type
        self.tableView.register(UINib(nibName: HiveListTableViewCell.nibName(), bundle: nil), forCellReuseIdentifier: HiveListTableViewCell.nibName())
        
        self.interactor.onViewDidLoad()
    }
}

extension HiveListViewController: HiveListViewControllerProtocol {
    func displayLoading(shown: Bool) {
        // TODO
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
        cell.selectionStyle = .none
        return cell
    }
}

extension HiveListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: NSLocalizedString("Label.Delete", comment: "")) {  (contextualAction, view, completion) in
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
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            let hiveId = hives[indexPath.row].id
//            self.interactor.onTapDelete(id: hiveId)
////            self.hives.remove(at: indexPath.row)
////            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
}
