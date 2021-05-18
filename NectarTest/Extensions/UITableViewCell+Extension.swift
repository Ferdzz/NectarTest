//
//  UITableViewCell+Extension.swift
//  NectarTest
//
//  Created by Frederic Deschenes on 2021-05-18.
//

import UIKit

extension UITableViewCell {
    static func nibName() -> String {
        return String(describing: Self.self)
    }
}
