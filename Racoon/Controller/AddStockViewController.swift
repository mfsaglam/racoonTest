//
//  AddStockViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 21.04.2021.
//

import UIKit

class AddStockViewController: UITableViewController {
    
    var delegate: ItemDelegate
    var isEditingStock: Bool
    var inventoryIndex: Int
    var stockIndex: Int?
    var navigationTitle: String {
        isEditingStock ? "Edit Stock" : "Add Stock"
    }
    
//    MARK: - Inits of AddStockViewController
    init?(coder: NSCoder, isEditingStock: Bool, inventoryIndex: Int, stockIndex: Int, delegate: ItemDelegate) {
        self.isEditingStock = isEditingStock
        self.inventoryIndex = inventoryIndex
        self.stockIndex = stockIndex
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    init?(coder: NSCoder, isEditingStock: Bool, inventoryIndex: Int, delegate: ItemDelegate) {
        self.isEditingStock = isEditingStock
        self.inventoryIndex = inventoryIndex
        self.delegate = delegate
        super.init(coder: coder)
    }
    
    required init(coder: NSCoder) {
        fatalError("")
    }
    
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var amountTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButtonTapped))
        self.navigationItem.rightBarButtonItem = saveButton
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.title = navigationTitle
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        amountTextField.becomeFirstResponder()
    }
    
    //MARK: - Selectors
    @objc func saveButtonTapped() {
        self.dismiss(animated: true) {
            guard let amount = Float(self.amountTextField.text ?? "") else { return }
            var unit: Item.StockType {
                switch self.unitSegment.selectedSegmentIndex {
                case 0: return .package
                case 1: return .piece
                default: return .package
                }
            }
            let newStock = Item.Stock(amount: amount, type: unit)
            if self.isEditingStock {
                self.delegate.item(editStockAt: self.inventoryIndex, stockIndex: self.stockIndex!, newStock: newStock)
            } else {
                self.delegate.item(addStockAt: self.inventoryIndex, newStock: newStock)
            }
        }
    }
    
    @objc func cancelButtonTapped() {
        self.navigationController?.dismiss(animated: true, completion: nil)
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

