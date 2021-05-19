//
//  HiveListInteractor.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation

protocol HiveListInteractorProtocol: class {
    func onViewDidLoad()
    func onRefresh(completion: @escaping () -> Void)
    func onTapDelete(id: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void)
}

class HiveListInteractor {
    
    private let hiveStore = HiveStore()
    
    private weak var viewController: HiveListViewControllerProtocol?
    
    init(viewController: HiveListViewControllerProtocol) {
        self.viewController = viewController
    }
    
    private func fetchData(displayLoading: Bool = true, completion: @escaping () -> Void) {
        self.viewController?.displayLoading(shown: displayLoading)
        self.hiveStore.getHives { [weak self] (hives) in
            self?.viewController?.show(hives: hives.sorted(by: { $0.name < $1.name }))
        } onError: { [weak self] (error) in
            print(error) // TODO: Handle error
        } completion: { [weak self] in
            self?.viewController?.displayLoading(shown: false)
            completion()
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
        self.hiveStore.processPendingDeletions {
            self.fetchData(completion: {})
        }
    }
    
    func onRefresh(completion: @escaping () -> Void) {
        self.hiveStore.processPendingDeletions {
            self.fetchData(displayLoading: false, completion: completion)
        }
    }
    
    func onTapDelete(id: String, onSuccess: @escaping () -> Void, onError: @escaping () -> Void) {
        self.deleteHive(id: id, onSuccess: onSuccess, onError: onError)
    }
}
