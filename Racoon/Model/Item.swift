//
//  Item.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import Foundation

struct Item {
    
    var name: String
    var packageQuantity: Float
    var unit: Item.Unit
    var inventory: [Stock] = []
    
    struct Stock {
        var amount: Float
        var type: Item.StockType
    }
    
    enum StockType {
        case package, piece
    }
    
    enum Unit {
        case kg, piece
    }
    
    enum Category {
        case all, zero, counted
    }
    
    var category: Item.Category {
        self.inventory.count == 0 ? .zero : .counted
    }
    
    var totalStock: Float {
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
}

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



