//
//  HiveStore.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import UIKit
import Alamofire
import CoreData

/// This class manages the fetching of Hives. This can come from either the API if available, or local
/// storage if the device is offline
class HiveStore {

    private let hiveApiManager = HiveApiManager()
    private let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // TODO: Move reachability to a generic class
    private let networkReachabilityManager = NetworkReachabilityManager()
    private var isNetworkReachable: Bool {
        networkReachabilityManager?.isReachable ?? false
    }
    
    // TODO: The CoreData handling belongs to a dedicated handler
    func getHives(
        onSuccess: @escaping ([Hive]) -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        if isNetworkReachable {
            hiveApiManager.getHives(onSuccess: { hives in
                // Transform the hives we've received into ManagedHives and insert them
                _ = hives.map({
                    let managedHive = ManagedHive(context: self.coreDataContext)
                    managedHive.id = $0.id
                    managedHive.date = $0.createdAt
                    managedHive.name = $0.name
                    managedHive.image = $0.image
                })
                try? self.coreDataContext.save()
                onSuccess(hives)
            }, onError: onError, completion: completion)
        } else {
            do {
                // Get the hives stored locally
                let managedHives: [ManagedHive] = try coreDataContext.fetch(ManagedHive.fetchRequest())
                // Transform the managed hive object into the model
                let hives = managedHives.compactMap({ Hive(id: $0.id!, createdAt: $0.date!, name: $0.name!, image: $0.image!) })
                onSuccess(hives)
            } catch {
                onError(error)
            }
            completion()
        }
    }
    
    func deleteHive(
        id: String,
        onSuccess: @escaping () -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        if isNetworkReachable {
            hiveApiManager.deleteHive(id: id, onSuccess: {
                onSuccess()
                // If the deletion was a success, also remove the hive from local data
                let fetchRequest: NSFetchRequest<ManagedHive> = ManagedHive.fetchRequest()
                fetchRequest.fetchLimit = 1
                fetchRequest.predicate = NSPredicate(format: "id == %@", id)
                // Get the ManagedHive with the id of the deleted item
                if let hive = try? self.coreDataContext.fetch(fetchRequest).first {
                    // Remove the hive from CoreData
                    self.coreDataContext.delete(hive)
                    try? self.coreDataContext.save()
                }
            }, onError: onError, completion: completion)
        } else {
            
        }
    }
}
