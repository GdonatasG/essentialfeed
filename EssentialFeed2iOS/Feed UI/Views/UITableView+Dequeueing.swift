//
//  UITableView+Dequeueing.swift
//  EssentialFeed2iOS
//
//  Created by Donatas Žitkus on 17/06/2025.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>() -> T {
        let identifier = String(describing: T.self)
        return dequeueReusableCell(withIdentifier: identifier) as! T
    }
}
