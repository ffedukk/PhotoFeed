//
//  CustomTableView.swift
//  PhotoFeed
//
//  Created by Фёдор Семенов on 14.06.2024.
//

import UIKit

final class CustomTableView: UITableView {

    override func touchesShouldCancel(in view: UIView) -> Bool {
        guard !(view is UIControl) else { return true }
        return super.touchesShouldCancel(in: view)
    }
}
