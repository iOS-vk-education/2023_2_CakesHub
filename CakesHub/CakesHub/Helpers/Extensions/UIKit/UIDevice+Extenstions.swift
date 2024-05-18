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

    var hasDynamicIsland: Bool {
        // 1. dynamicIsland only support iPhone
        guard userInterfaceIdiom == .phone else {
            return false
        }

        // 2. Get key window, working after sceneDidBecomeActive
        guard let window = (UIApplication.shared.connectedScenes.compactMap {
            $0 as? UIWindowScene
        }.flatMap { $0.windows }.first { $0.isKeyWindow}) else {
            return false
        }

        // 3.It works properly when the device orientation is portrait
        return window.safeAreaInsets.top >= 51
    }
}

extension UIScreen {
    var displayCornerRadius: CGFloat {
        guard let cornerRadius = self.value(forKey: "_displayCornerRadius") as? CGFloat else {
            return 0
        }
        return cornerRadius
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


extension UIScreen {
    static var current: UIScreen? {
        UIWindow.current?.screen
    }
}
