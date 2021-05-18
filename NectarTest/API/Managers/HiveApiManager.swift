//
//  HiveApiManager.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import Foundation
import Alamofire

class HiveApiManager: BaseApiManager {
    
    private enum Path {
        case getHives
        
        var url: String {
            switch self {
            case .getHives: return "hives/"
            }
        }
        
        var method: HTTPMethod {
            switch self {
            case .getHives: return .get
            }
        }
    }
    
    // TODO: The requests could be made common by making a protocol for Path
    func getHives(
        onSuccess: @escaping ([Hive]) -> Void,
        onError: @escaping (Error) -> Void,
        completion: @escaping () -> Void
    ) {
        let path = Path.getHives
        guard let url = URL(string: baseUrl.appending(path.url)) else { return }
        self.request(url: url, method: path.method, onSuccess: onSuccess, onError: onError, completion: completion)
    }
}
