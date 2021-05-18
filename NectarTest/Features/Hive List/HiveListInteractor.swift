//
//  HiveListInteractor.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation

protocol HiveListInteractorProtocol: class {
    func onViewDidLoad()
}

class HiveListInteractor {
    
    private let hiveApiManager = HiveApiManager()
    
    private weak var viewController: HiveListViewControllerProtocol?
    
    init(viewController: HiveListViewControllerProtocol) {
        self.viewController = viewController
    }
    
    private func fetchData() {
        self.viewController?.displayLoading(shown: true)
        self.hiveApiManager.getHives { [weak self] (hives) in
            self?.viewController?.show(hives: hives)
        } onError: { [weak self] (error) in
            print(error) // TODO: Handle error
        } completion: { [weak self] in
            self?.viewController?.displayLoading(shown: false)
        }
    }
}

extension HiveListInteractor: HiveListInteractorProtocol {
    func onViewDidLoad() {
        self.fetchData()
    }
}
