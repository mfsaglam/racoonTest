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
    
    func addObserver(observer: ItemManagerObserver) {
        observers.append(observer)
    }
    
    func getData() -> Results<Item> {
        dataArray = realm.objects(Item.self)
        return dataArray
    }
    
    func deleteItem(at index: Int) {
        let item = dataArray[index]
        do {
            try realm.write {
                realm.delete(item)
                dataArray = getData()
            }
        } catch {
            print("error deleting object from realm \(error)")
        }
    }
    
    func addItem(_ item: Item) {
        do {
            try realm.write {
                realm.add(item)
                dataArray = getData()
            }
        } catch {
            fatalError("Error saving objects to realm \(error)")
        }
    }
    
    func editItem(at index: Int, name: String, packageQuantity: Float, unit: Item.Unit) {
        do {
            try realm.write {
                dataArray[index].name = name
                dataArray[index].packageQuantity = packageQuantity
                dataArray[index].unit = unit
                dataArray = getData()
            }
        } catch {
            print("error editing onject in realm \(error)")
        }
    }
    
    func editStock(at index: Int, stockIndex: Int, newStock: Stock) {
        do {
            try realm.write {
                dataArray[index].inventory[stockIndex] = newStock
                dataArray = getData()
            }
        } catch {
            print("error editing stock \(error)")
        }
    }
    
    func deleteStock(at index: Int, stockIndex: Int) {
        do {
            try realm.write {
                dataArray[index].inventory.remove(at: stockIndex)
                dataArray = getData()
            }
        } catch {
            print("error deleting stock \(error)")
        }
    }
    
    func updateInventory(at index: Int, inventory: List<Stock>) {
        do {
            try realm.write {
                dataArray[index].inventory = inventory
                dataArray = getData()
            }
        } catch {
            print("Error updaing inventory \(error)")
        }
    }
    
    func addStock(at index: Int, newStock: Stock) {
        do {
            try realm.write {
                dataArray[index].inventory.append(newStock)
                dataArray = getData()
            }
        } catch {
            print("error adding stock to object in realm \(error)")
        }
        print("inventory \(dataArray[index].inventory) added to item \(dataArray[index].name)")
    }
    
    func resetInventory() {
        do {
            try realm.write {
                for index in 0..<dataArray.count {
                    dataArray[index].inventory = List<Stock>()
                    dataArray = getData()
                }
            }
        } catch {
            print("Error resetting inventories \(error)")
        }
        
    }
}
