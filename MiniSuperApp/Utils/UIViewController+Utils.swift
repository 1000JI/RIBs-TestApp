//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by 천지운 on 11/4/23.
//

import UIKit

extension UIViewController {
    
    func setupNavigationItem(target: Any?, action: Selector?) {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(
                systemName: "xmark",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 18, weight: .semibold)
            ),
            style: .plain,
            target: target,
            action: action
        )
    }
    
}
