//
//  InventoryController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 21.04.2021.
//

import UIKit

class InventoryController: UITableViewController {
    
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
    }        
    
    //MARK: - Selectors
    @objc func saveButtonTapped() {
        // set the inventory property array of the item
        guard let amount = amountTextField.text else { return }
        var unit: Item.QuantityType {
            switch unitSegment.selectedSegmentIndex {
            case 0: return .package
            case 1: return .piece
            default: return .package
            }
        }
        print("inventory \(amount), \(unit)  succesfully created or adjusted")
    }
}
