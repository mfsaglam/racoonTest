//
//  File.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation

struct ItemManager {
    var dataArray: [Item] = [
        Item(name: "Bacon Kg", packageQuantity: 100, unit: .kg),
        Item(name: "Fish Can 250g", packageQuantity: 50, unit: .piece),
        Item(name: "Patty pcs", packageQuantity: 100, unit: .piece),
        Item(name: "Not Counted Item", packageQuantity: 0, unit: .kg),
        Item(name: "Item with Inventory", packageQuantity: 9, unit: .piece, inventory: [Item.Inventory(amount: 100, type: .package), Item.Inventory(amount: 18, type: .piece)])
    ]
    
    func getData() -> [Item] {
        return dataArray
    }
}
