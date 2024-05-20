//
//  Date+Extenstions.swift
//  CakesHub
//
//  Created by Dmitriy Permyakov on 04.04.2024.
//  Copyright 2023 © VK Team CakesHub. All rights reserved.
//

import Foundation

extension Date {

    func formattedString(format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
