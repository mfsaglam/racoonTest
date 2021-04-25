//
//  EditItemDelegate.swift
//  Racoon
//
//  Created by Fatih Sağlam on 25.04.2021.
//

import Foundation

protocol EditItemDelegate {
    func EditItemWith(newName: String, newUnit: Item.ItemUnit, newPackageQuantity: Int, indexPath: Int)
}
