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
    var itemUnitType: Item.Unit
    var segmentTitle: String {
        switch itemUnitType {
        case .kg: return "Grams"
        case .piece: return "Piece"
        }
    }
    var navigationTitle: String {
        isEditingStock ? "Edit Stock" : "Add Stock"
    }
    
//    MARK: - Inits of AddStockViewController
    init?(coder: NSCoder, isEditingStock: Bool, inventoryIndex: Int, stockIndex: Int, itemUnitType: Item.Unit, delegate: ItemDelegate) {
        self.isEditingStock = isEditingStock
        self.inventoryIndex = inventoryIndex
        self.stockIndex = stockIndex
        self.delegate = delegate
        self.itemUnitType = itemUnitType
        super.init(coder: coder)
    }
    
    init?(coder: NSCoder, isEditingStock: Bool, inventoryIndex: Int, itemUnitType: Item.Unit, delegate: ItemDelegate) {
        self.isEditingStock = isEditingStock
        self.inventoryIndex = inventoryIndex
        self.itemUnitType = itemUnitType
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
        self.unitSegment.setTitle("\(segmentTitle)", forSegmentAt: 1)
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
            let newStock = Stock(amount: amount, type: unit)
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

