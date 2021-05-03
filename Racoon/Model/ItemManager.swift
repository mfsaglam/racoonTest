//
//  ItemManager.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation

class ItemManager {
    private (set) var dataArray: [Item] = [Item(name: "1", packageQuantity: 1, unit: .kg),
                                           Item(name: "2", packageQuantity: 2, unit: .kg),
                                           Item(name: "3", packageQuantity: 3, unit: .piece),
    ]
    
    func getData() -> [Item] {
        return dataArray
    }
    
    func deleteItem(at index: Int) {
        dataArray.remove(at: index)
    }
    
    func addItem(_ item: Item) {
        dataArray.append(item)
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
    
    func deleteStock(at index: Int, inventoryIndex: Int) {
        dataArray[index].inventory.remove(at: inventoryIndex)
    }
    
    func updateInventory(at index: Int, inventory: [Item.Stock]) {
        dataArray[index].inventory = inventory
    }
    
    func addStock(at index: Int, newStock: Item.Stock) {
        dataArray[index].inventory.append(newStock)
    }
}
