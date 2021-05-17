//
//  AddStockViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 21.04.2021.
//

import UIKit

class AddStockViewController: UITableViewController {
    
    var delegate: ItemDelegate?
    var isEditingStock: Bool
    var inventoryIndex: Int?
    var selectedIndex: Int
    
    init?(coder: NSCoder, isEditingStock: Bool, inventoryIndex: Int? = nil, selectedIndex: Int) {
        self.isEditingStock = isEditingStock
        self.inventoryIndex = inventoryIndex
        self.selectedIndex = selectedIndex
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this viewController with these properties: isEditingStock, inventoryIndex and selectedIndex")
    }
    
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = cancelButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountTextField.becomeFirstResponder()
    }
    
    //MARK: - Selectors
    @objc func saveButtonTapped() {
        self.dismiss(animated: true) {
            guard let amount = Float(self.amountTextField.text ?? "\(0)") else { return }
            var unit: Item.StockType {
                switch self.unitSegment.selectedSegmentIndex {
                case 0: return .package
                case 1: return .piece
                default: return .package
                }
            }
            let newStock = Item.Stock(amount: amount, type: unit)
            if self.isEditingStock {
                self.delegate?.item(editStockAt: self.selectedIndex, inventoryIndex: self.inventoryIndex!, newStock: newStock)
            } else {
                self.delegate?.item(addStockAt: self.selectedIndex, newStock: newStock)
            }
        }
    }
    
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate

extension AddStockViewController {
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("deleted")
        }
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

