//
//  Item.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import Foundation

struct Item {
    var name: String
    var packageQuantity: Int
    var unit: ItemUnit
    var totalInventory: Int {
        return inventory.reduce(0, +)
    }
    var inventory: [Int] = [0]
}

enum ItemUnit {
    case kg
    case piece
}

enum quantityType {
    case package
    case piece
}
