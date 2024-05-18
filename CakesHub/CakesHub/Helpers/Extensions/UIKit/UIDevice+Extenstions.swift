//
//  UIDevice+Extenstions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 03/12/2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import UIKit

extension UIDevice {

    static var isSe: Bool {
        self.current.name == "iPhone SE (3rd generation)"
    }
}

extension UIScreen {

    var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: "_displayCornerRadius") as? CGFloat else {
            return 0
        }
        return cornerRadius
    }

    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}

extension UIWindow {

    static var current: UIWindow? {
        for scene in UIApplication.shared.connectedScenes {
            guard let windowScene = scene as? UIWindowScene else { continue }
            for window in windowScene.windows {
                if window.isKeyWindow { return window }
            }
        }
        return nil
    }
}
