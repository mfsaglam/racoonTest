//
//  CreateItemDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 17.04.2021.
//

import Foundation
import RealmSwift

protocol ItemDelegate {
    var manager: ItemManager { get set }
    
    func item(deleteItemAt index: Int)

    func item(addItem item: Item)

    func item(editItemAt index: Int, name: String, packageQuantity: Float, unit: Item.Unit)

    func item(editStockAt index: Int, stockIndex: Int, newStock: Stock)
    
    func item(deleteStockAt index: Int, stockIndex: Int)

    func item(updateInventoryAt index: Int, inventory: List<Stock>)

    func item(addStockAt index: Int, newStock: Stock)
    
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

    func item(editStockAt index: Int, stockIndex: Int, newStock: Stock) {
        manager.editStock(at: index, stockIndex: stockIndex, newStock: newStock)
    }
    
    func item(deleteStockAt index: Int, stockIndex: Int) {
        manager.deleteStock(at: index, stockIndex: stockIndex)
    }

    func item(updateInventoryAt index: Int, inventory: List<Stock>) {
        manager.updateInventory(at: index, inventory: inventory)
    }

    func item(addStockAt index: Int, newStock: Stock) {
        manager.addStock(at: index, newStock: newStock)
    }
    
    func resetInventory() {
        manager.resetInventory()
    }
}
