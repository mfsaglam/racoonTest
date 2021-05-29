//
//  Stock.swift
//  Racoon
//
//  Created by Fatih Sağlam on 26.05.2021.
//

import Foundation
import RealmSwift

class Stock: Object {
    @objc dynamic var amount: Float
    @objc dynamic var type: Item.StockType
    var parentCategory = LinkingObjects(fromType: Item.self, property: "inventory")
    
    init(amount: Float, type: Item.StockType) {
        self.amount = amount
        self.type = type
    }
}
