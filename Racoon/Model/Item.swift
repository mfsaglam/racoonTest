//
//  Item.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import Foundation
import RealmSwift

class Item: Object {
    
    dynamic var name: String
    dynamic var packageQuantity: Float
    dynamic var unit: Item.Unit
    dynamic var inventory: [Stock] = []
    
    class Stock: Object {
        dynamic var amount: Float
        dynamic var type: Item.StockType
        
        init(amount: Float, type: Item.StockType) {
            self.amount = amount
            self.type = type
        }
    }
    
    @objc enum StockType: Int, RealmEnum {
        case package, piece
    }
    
    @objc enum Unit: Int, RealmEnum {
        case kg, piece
    }
    
    @objc enum Category: Int, RealmEnum {
        case all, zero, counted
    }
    
    dynamic var category: Item.Category {
        self.inventory.count == 0 ? .zero : .counted
    }
    
    dynamic var totalStock: Float {
        var totalStock: Float = 0
        for stock in inventory {
            if stock.type == .package {
                totalStock += stock.amount * packageQuantity
            } else {
                totalStock += stock.amount
            }
        }
        return totalStock
    }
    
//MARK: - İnitializers
    
    init(name:String , packageQuantity: Float , unit: Item.Unit, inventory: [Item.Stock] = []) {
        self.name = name
        self.packageQuantity = packageQuantity
        self.unit = unit
        self.inventory = inventory
    }
}

//MARK: - Extensions

extension Item.Category: CaseIterable { }

extension Item.Category: RawRepresentable {
    typealias RawValue = String
    
    init?(rawValue: RawValue) {
      switch rawValue {
      case "All": self = .all
      case "Zero": self = .zero
      case "Counted": self = .counted
      default: return nil
      }
    }
    
    var rawValue: RawValue {
      switch self {
      case .all: return "All"
      case .zero: return "Zero"
      case .counted: return "Counted"
      }
    }
}


