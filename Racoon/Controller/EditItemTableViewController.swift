//
//  EditItemTableViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 25.04.2021.
//

import UIKit

class EditItemTableViewController: UITableViewController {
    
    var delegate: ItemDelegate?
    var selectedItem: Item
    var selectedIndex: Int
    
    init?(coder: NSCoder, selectedItem: Item, indexPath: Int) {
        self.selectedItem = selectedItem
        self.selectedIndex = indexPath
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("you must create this viewController with an item.")
    }
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var quantityTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelSelected))
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSelected))
        navigationItem.leftBarButtonItem = cancel
        navigationItem.rightBarButtonItem = done
        nameTextField.placeholder = selectedItem.name
        quantityTextField.placeholder = "\(selectedItem.packageQuantity)"
        unitSegment.selectedSegmentIndex = selectedItem.unit == .piece ? 0 : 1
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
    }
    
    //MARK: - Selectors
    @objc func cancelSelected() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func doneSelected() {
        self.dismiss(animated: true) {
            guard let newName = self.nameTextField.text, let newQuantity = Float(self.quantityTextField.text!)
            else {
                //TODO: - Handle error
                return
            }
            var newUnit: Item.Unit {
                self.unitSegment.selectedSegmentIndex == 0 ? .piece : .kg
            }
            self.delegate?.item(editItemAt: self.selectedIndex, name: newName, packageQuantity: newQuantity, unit: newUnit)
        }
    }
}
