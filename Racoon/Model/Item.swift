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
    var unit: Item.Unit
    var totalStock: Int {
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
    var inventory: [Stock] = []
    
    enum StockType {
        case package
        case piece
    }
    
    struct Stock {
        var amount: Int
        var type: Item.StockType
    }
    
    enum Unit {
        case kg
        case piece
    }
}



