//
//  Stock.swift
//  Racoon
//
//  Created by Fatih Sağlam on 26.05.2021.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var amount: Float = 0.0
    @objc dynamic var type: Item.StockType = .package
    var parentCategory = LinkingObjects(fromType: Item.self, property: "inventory")
    
    convenience init(amount: Float, type: Item.StockType) {
        self.init()
        self.amount = amount
        self.type = type
    }
}
