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
    var unit: Item.ItemUnit
    var totalInventory: Int {
        var totalStock = 0
        for stock in inventory {
            if stock.type == .package {
                totalStock += stock.amount * packageQuantity
            } else {
                totalStock += stock.amount
            }
        }
        return totalStock
    }
    var inventory: [Inventory] = []
    
    enum QuantityType {
        case package
        case piece
    }
    
    struct Inventory {
        var amount: Int
        var type: Item.QuantityType
    }
    
    enum ItemUnit {
        case kg
        case piece
    }
}



