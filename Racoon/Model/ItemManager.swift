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
    
    mutating func deleteItem(at index: Int) {
        dataArray.remove(at: index)
    }
    
    mutating func editItem(at index: Int, name: String, packageQuantity: Int, unit: Item.ItemUnit) {
        dataArray[index].name = name
        dataArray[index].packageQuantity = packageQuantity
        dataArray[index].unit = unit
    }
    
    mutating func editStock(at index: Int, inventoryIndex: Int, newStock: Int, newType: Item.QuantityType) {
        dataArray[index].inventory[inventoryIndex].amount = newStock
        dataArray[index].inventory[inventoryIndex].type = newType
    }
}
