//
//  ItemManager.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation

protocol ItemManagerObserver {
    func didUpdateDataArray(to dataArray: [Item])
}

class ItemManager {
    
    var observers = [ItemManagerObserver]()
    
    static let shared = ItemManager.init()
    private init() { }
    
    private (set) var dataArray: [Item] = [Item(name: "1", packageQuantity: 1, unit: .kg, inventory: [Item.Stock(amount: 23.44, type: .package)]),
                                           Item(name: "2", packageQuantity: 2, unit: .kg),
                                           Item(name: "3", packageQuantity: 3, unit: .piece),
    ] {
        didSet {
            observers.forEach { observer in
                observer.didUpdateDataArray(to: dataArray)
            }
        }
    }
    
    func addObserver(observer: ItemManagerObserver) {
        observers.append(observer)
    }
    
    func getData() -> [Item] {
        return dataArray
    }
    
    func deleteItem(at index: Int) {
        dataArray.remove(at: index)
    }
    
    func addItem(_ item: Item) {
        dataArray.append(item)
    }
    
    func editItem(at index: Int, name: String, packageQuantity: Float, unit: Item.Unit) {
        dataArray[index].name = name
        dataArray[index].packageQuantity = packageQuantity
        dataArray[index].unit = unit
    }
    
    func editStock(at index: Int, stockIndex: Int, newStock: Item.Stock) {
        dataArray[index].inventory[stockIndex] = newStock
    }
    
    func deleteStock(at index: Int, stockIndex: Int) {
        dataArray[index].inventory.remove(at: stockIndex)
    }
    
    func updateInventory(at index: Int, inventory: [Item.Stock]) {
        dataArray[index].inventory = inventory
        print("inventory \(dataArray[index].inventory) added to item \(dataArray[index].name)")
    }
    
    func addStock(at index: Int, newStock: Item.Stock) {
        dataArray[index].inventory.append(newStock)
        print("inventory \(dataArray[index].inventory) added to item \(dataArray[index].name)")
    }
    
    func resetInventory() {
        for index in 0..<dataArray.count {
            dataArray[index].inventory = []
        }
    }
}
