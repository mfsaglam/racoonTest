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
    
    var addItem: ((Item) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.prefersLargeTitles = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func savePressed(_ sender: UIBarButtonItem) {
        guard let itemName = nameTextField.text,
              let packQuantity = Int(quantityTextField.text!) else {
            //handle error
            return
        }
        var unit: ItemUnit {
            return unitSegment.selectedSegmentIndex == 0 ? .piece : .kg
        }
        let item = Item(name: itemName, quantity: packQuantity, unit: unit)
        print(item)
        addItem?(item)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
