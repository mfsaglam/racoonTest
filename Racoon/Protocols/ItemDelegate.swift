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

    func item(editItemAt index: Int, name: String, packageQuantity: Float, unit: Item.Unit)

    func item(editStockAt index: Int, inventoryIndex: Int, newStock: Item.Stock)
    
    func item(deleteStockAt index: Int, inventoryIndex: Int)

    func item(updateInventoryAt index: Int, inventory: [Item.Stock])

    func item(addStockAt index: Int, newStock: Item.Stock)
    
    func resetInventory()
}

extension ItemDelegate {
        
    var manager: ItemManager {
        ItemManager.shared
    }
        
    func item(deleteItemAt index: Int) {
        manager.deleteItem(at: index)
    }

    func item(addItem item: Item) {
        manager.addItem(item)
    }

    func item(editItemAt index: Int, name: String, packageQuantity: Float, unit: Item.Unit) {
        manager.editItem(at: index, name: name, packageQuantity: packageQuantity, unit: unit)
    }

    func item(editStockAt index: Int, inventoryIndex: Int, newStock: Item.Stock) {
        manager.editStock(at: index, inventoryIndex: inventoryIndex, newStock: newStock)
    }
    
    func item(deleteStockAt index: Int, inventoryIndex: Int) {
        manager.deleteStock(at: index, inventoryIndex: inventoryIndex)
    }

    func item(updateInventoryAt index: Int, inventory: [Item.Stock]) {
        manager.updateInventory(at: index, inventory: inventory)
    }

    func item(addStockAt index: Int, newStock: Item.Stock) {
        manager.addStock(at: index, newStock: newStock)
    }
    
    func resetInventory() {
        manager.resetInventory()
    }
}
