//
//  HiveStore.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation
import Alamofire

/// This class manages the fetching of Hives. This can come from either the API if available, or local
/// storage if the device is offline
class HiveStore {

    private let hiveApiManager = HiveApiManager()

    // TODO: Move reachability to a generic class
    private let networkReachabilityManager = NetworkReachabilityManager()
    private var isNetworkReachable: Bool {
        networkReachabilityManager?.isReachable ?? false
    }
    
    func getHives(
        onSuccess: @escaping ([Hive]) -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        if isNetworkReachable {
            hiveApiManager.getHives(onSuccess: onSuccess, onError: onError, completion: completion)
        } else {
            // TODO: Local
        }
    }
    
    func deleteHive(
        id: String,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        if isNetworkReachable {
            hiveApiManager.deleteHive(id: id, onSuccess: onSuccess, onError: onError, completion: completion)
        } else {
            // TODO: Local
        }
    }
}
