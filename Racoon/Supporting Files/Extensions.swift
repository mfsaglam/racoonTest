//
//  Extensions.swift
//  Racoon
//
//  Created by Fatih Sağlam on 19.05.2021.
//

import Foundation

extension Float {
    var clean: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
