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
        navigationItem.backButtonTitle = ""
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let itemName = nameTextField.text, let packQuantity = Int(quantityTextField.text!) else {
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                return
            }
            let alert = UIAlertController(title: "Something is missing.", message: "You have to enter a name and quantity.", preferredStyle: .alert)
            alert.addAction(okAction)
            self.present(alert, animated: true)
            return
        }
        
        var unit: ItemUnit {
            return unitSegment.selectedSegmentIndex == 0 ? .piece : .kg
        }
        
        let item = Item(name: itemName, packageQuantity: packQuantity, unit: unit)
        print("\(item) is succesfully created")
        delegate?.updateViewWithNewItem(item: item)
    }
}
