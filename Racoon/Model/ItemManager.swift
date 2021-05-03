//
//  ItemManager.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation

class ItemManager {
    private (set) var dataArray: [Item] = []
    
    func getData() -> [Item] {
        return dataArray
    }
    
    func deleteItem(at index: Int) {
        dataArray.remove(at: index)
    }
    
    func addItem(_ item: Item) {
        dataArray.append(item)
        print("item added to data array, its now \(dataArray.count)")
    }
    
    func editItem(at index: Int, name: String, packageQuantity: Int, unit: Item.Unit) {
        dataArray[index].name = name
        dataArray[index].packageQuantity = packageQuantity
        dataArray[index].unit = unit
    }
    
    func editStock(at index: Int, inventoryIndex: Int, newStock: Int, newType: Item.StockType) {
        dataArray[index].inventory[inventoryIndex].amount = newStock
        dataArray[index].inventory[inventoryIndex].type = newType
    }
    
    func updateInventory(at index: Int, inventory: [Item.Stock]) {
        dataArray[index].inventory = inventory
    }
    
    func addStock(at index: Int, newStock: Item.Stock) {
        print(dataArray)
        dataArray[index].inventory.append(newStock)
    }
}
