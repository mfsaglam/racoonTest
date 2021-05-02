//
//  ItemManager.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation

struct ItemManager {
    var dataArray: [Item] = []
    
    func getData() -> [Item] {
        return dataArray
    }
    
    mutating func deleteItem(at index: Int) {
        dataArray.remove(at: index)
    }
    
    mutating func addItem(_ item: Item) {
        dataArray.append(item)
    }
    
    mutating func editItem(at index: Int, name: String, packageQuantity: Int, unit: Item.Unit) {
        dataArray[index].name = name
        dataArray[index].packageQuantity = packageQuantity
        dataArray[index].unit = unit
    }
    
    mutating func editStock(at index: Int, inventoryIndex: Int, newStock: Int, newType: Item.StockType) {
        dataArray[index].inventory[inventoryIndex].amount = newStock
        dataArray[index].inventory[inventoryIndex].type = newType
    }
    
    mutating func updateInventory(at index: Int, inventory: [Item.Stock]) {
        dataArray[index].inventory = inventory
    }
    
    mutating func addStock(at index: Int, newStock: Item.Stock) {
        dataArray[index].inventory.append(newStock)
    }
}
