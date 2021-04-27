//
//  CreateItemDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 17.04.2021.
//

import Foundation

protocol ItemDelegate {
    func updateViewWithNewItem(item: Item)
    func updateViewWithNewStock(stock: Item.Inventory)
    func EditItemWith(newName: String, newUnit: Item.ItemUnit, newPackageQuantity: Int, indexPath: Int)
}

extension ItemDelegate {
    func updateViewWithNewItem(item: Item) {
        //default implementation here
    }
    
    func updateViewWithNewStock(stock: Item.Inventory) {
        //default implementation here
    }
    
    func EditItemWith(newName: String, newUnit: Item.ItemUnit, newPackageQuantity: Int, indexPath: Int) {
        //default implementation here
    }
}
