//
//  CreateItemDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 17.04.2021.
//

import Foundation

protocol ItemDelegate {
    var manager: ItemManager { get set }
    
    func item(deleteItemAt index: Int)

    func item(addItem item: Item)

    func item(editItemAt index: Int, name: String, packageQuantity: Int, unit: Item.Unit)

    func item(editStockAt index: Int, inventoryIndex: Int, newStock: Int, newType: Item.StockType)

    func item(updateInventoryAt index: Int, inventory: [Item.Stock])

    func item(addStockAt index: Int, newStock: Item.Stock)
}

extension ItemDelegate {
    
    //TODO: - I gave default implementations but these functions are still required by the class who conforms them. Why?
    
    var manager: ItemManager {
        return ItemManager()
    }
        
    mutating func item(deleteItemAt index: Int) {
        manager.deleteItem(at: index)
    }

    mutating func item(addItem item: Item) {
        manager.addItem(item)
    }

    mutating func item(editItemAt index: Int, name: String, packageQuantity: Int, unit: Item.Unit) {
        manager.editItem(at: index, name: name, packageQuantity: packageQuantity, unit: unit)
    }

    mutating func item(editStockAt index: Int, inventoryIndex: Int, newStock: Int, newType: Item.StockType) {
        manager.editStock(at: index, inventoryIndex: inventoryIndex, newStock: newStock, newType: newType)
    }

    mutating func item(updateInventoryAt index: Int, inventory: [Item.Stock]) {
        manager.updateInventory(at: index, inventory: inventory)
    }

    mutating func item(addStockAt index: Int, newStock: Item.Stock) {
        manager.addStock(at: index, newStock: newStock)
    }
}
