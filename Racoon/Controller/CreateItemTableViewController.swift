//
//  CreateItemTableViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 11.04.2021.
//

import UIKit

class CreateItemTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var quantityTextField: UITextField!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var delegate: CreateItemDelegate?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.prefersLargeTitles = true
        nameTextField?.becomeFirstResponder()
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let itemName = nameTextField.text,
              let packQuantity = Int(quantityTextField.text!) else {
            //handle error, show an alert
            return
        }
        var unit: ItemUnit {
            return unitSegment.selectedSegmentIndex == 0 ? .piece : .kg
        }
        let item = Item(name: itemName, quantity: packQuantity, unit: unit)
        print("\(item) is succesfully created")
        delegate?.updateViewWithNewItem(item: item)
        navigationController?.popViewController(animated: true)
    }
}
