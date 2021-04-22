//
//  CreateNewStockDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 22.04.2021.
//

import Foundation

protocol CreateNewStockDelegate {
    func updateViewWithNewStock(stock: Item.Inventory)
}
