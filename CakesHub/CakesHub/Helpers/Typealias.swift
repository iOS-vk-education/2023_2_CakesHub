//
//  Typealias.swift
//  CHMUIKIT
//
//  Created by Дмитрий Пермяков on 06.10.2023.
//

import SwiftUI
import UIKit

typealias CHMVoidBlock = () -> Void
typealias CHMViewBlock<T: UIView> = (T) -> Void
typealias CHMIntBlock = (Int) -> Void
typealias CHMStringBlock = (String) -> Void
typealias CHMBoolBlock = (Bool) -> Void
typealias CHMGenericBlock<T> = (T) -> Void
typealias CHMBinding<T> = (Binding<T>) -> Void
typealias CHMResultBlock<T, T1: Error> = (Result<T, T1>) -> Void
