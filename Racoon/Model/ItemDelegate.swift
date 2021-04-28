//
//  CreateItemDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 17.04.2021.
//

import Foundation

protocol ItemDelegate {
    func item(updateViewWithNewItem item: Item)
    func item(updateViewWithNewStock stock: Item.Stock)
    func item(editItemWithNewName name: String, newUnit: Item.Unit, newPackageQuantity: Int, indexPath: Int)
    func item(updateInventoryWithNewInventory inventory: [Item.Stock], indexPath: Int)
}

extension ItemDelegate {
    func item(updateViewWithNewItem item: Item) {
        //default
    }
    func item(updateViewWithNewStock stock: Item.Stock) {
        //default
    }
    func item(editItemWithNewName name: String, newUnit: Item.Unit, newPackageQuantity: Int, indexPath: Int) {
        //default
    }
    func item(updateInventoryWithNewInventory inventory: [Item.Stock], indexPath: Int) {
        //default
    }
}
