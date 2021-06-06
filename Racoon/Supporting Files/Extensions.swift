//
//  Extensions.swift
//  Racoon
//
//  Created by Fatih Sağlam on 19.05.2021.
//

import Foundation
import RealmSwift

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}

extension Results {
    public func filter(_ isIncluded: (Self.Element) -> Bool) -> List<Element> {
        var list = List<Element>()
        for object in self {
            if isIncluded(object) {
                list.append(object)
            }
        }
        return list
    }
}
