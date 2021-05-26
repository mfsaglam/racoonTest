//
//  ItemManager.swift
//  Racoon
//
//  Created by Fatih Sağlam on 23.04.2021.
//

import Foundation
import RealmSwift

protocol ItemManagerObserver {
    func didUpdateDataArray(to dataArray: Results<Item>)
}

class ItemManager {
    
    let realm = try! Realm()
    
    var observers = [ItemManagerObserver]()
    
    static let shared = ItemManager.init()
    private init() { }
    
    private (set) var dataArray: Results<Item> {
        get {
            return realm.objects(Item.self)
        } set {
            observers.forEach { observer in
                observer.didUpdateDataArray(to: newValue)
            }
        }
    }
    
    private func save(item: Item) {
        do {
            try realm.write {
                realm.add(item)
            }
        } catch {
            fatalError("Error saving objects to realm \(error)")
        }
    }
    
    func addObserver(observer: ItemManagerObserver) {
        observers.append(observer)
    }
    
    func getData() -> Results<Item> {
        dataArray = realm.objects(Item.self)
        return dataArray
    }
    
    func deleteItem(at index: Int) {
        
    }
    
    func addItem(_ item: Item) {
        save(item: item)
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
