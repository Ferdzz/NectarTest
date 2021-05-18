//
//  HiveListInteractor.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation

protocol HiveListInteractorProtocol: class {
    func onViewDidLoad()
    func onTapDelete(id: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
}

class HiveListInteractor {
    
    private let hiveStore = HiveStore()
    
    private weak var viewController: HiveListViewControllerProtocol?
    
    init(viewController: HiveListViewControllerProtocol) {
        self.viewController = viewController
    }
    
    private func fetchData() {
        self.viewController?.displayLoading(shown: true)
        self.hiveStore.getHives { [weak self] (hives) in
            self?.viewController?.show(hives: hives.sorted(by: { $0.name < $1.name }))
        } onError: { [weak self] (error) in
            print(error) // TODO: Handle error
        } completion: { [weak self] in
            self?.viewController?.displayLoading(shown: false)
        }
    }
    
    private func deleteHive(id: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        self.hiveStore.deleteHive(id: id) {
            onSuccess()
        } onError: { (error) in
            onError()
        } completion: {
            // Nothing to do on completion
        }
    }
}

extension HiveListInteractor: HiveListInteractorProtocol {
    
    func onViewDidLoad() {
        self.fetchData()
    }
    
    func onTapDelete(id: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        self.deleteHive(id: id, onSuccess: onSuccess, onError: onError)
    }
}
