//
//  UINavigationController+Extenstions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 21.03.2024.
//

import UIKit

extension UINavigationController {

    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
