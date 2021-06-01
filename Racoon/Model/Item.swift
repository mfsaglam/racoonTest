//
//  Item.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @objc dynamic var name: String = ""
    @objc dynamic var packageQuantity: Float = 0.0
    @objc dynamic var unit: Item.Unit = .kg
    var inventory: List<Stock> = List<Stock>()
    
    @objc enum StockType: Int, RealmEnum {
        case package, piece
    }
    
    @objc enum Unit: Int, RealmEnum {
        case kg, piece
    }
    
    @objc enum Category: Int, RealmEnum {
        case all, zero, counted
    }
    
    @objc dynamic var category: Item.Category {
        self.inventory.count == 0 ? .zero : .counted
    }
    
    @objc dynamic var totalStock: Float {
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
    
//MARK: - Initializers
    
    convenience init(name:String , packageQuantity: Float , unit: Item.Unit, inventory: List<Stock> = List<Stock>()) {
        self.init()
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

//extension Item.StockType: RawRepresentable {
//    typealias RawValue = String
//
//    init?(rawValue: RawValue) {
//        switch rawValue {
//        case "Package" : self = .package
//        case "Piece" : self = .piece
//        default: return nil
//        }
//    }
//
//    var rawValue: RawValue {
//        switch self {
//        case .package: return "Package"
//        case .piece: return "Piece"
//        }
//    }
//}


