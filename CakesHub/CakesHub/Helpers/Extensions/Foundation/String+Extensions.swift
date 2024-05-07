//
//  String+Ext.swift
//  CakeHubApplication
//
//  Created by Дмитрий Пермяков on 04.10.2023.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

// MARK: VALUES

extension String {

    static let space = " "
    static let clear = ""
    static let bullet = "·"
    static let plusSign = "+"
    static let minusSign = "-"
    static let chevron = "›"
    static let rub = "₽"
}

// MARK: METHODs

extension String {

    var toDate: Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return .now
        }
    }
}
