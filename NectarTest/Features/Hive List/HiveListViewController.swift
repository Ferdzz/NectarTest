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
        return cell
    }
}

extension HiveListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
