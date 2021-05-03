//
//  AddStockViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 21.04.2021.
//

import UIKit

class AddStockViewController: UITableViewController {
    
    var delegate: ItemDelegate?
    var selectedIndex: Int?
    
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
        // set the inventory property array of the item
        guard let amount = Int(amountTextField.text ?? "\(0)") else { return }
        var unit: Item.StockType {
            switch unitSegment.selectedSegmentIndex {
            case 0: return .package
            case 1: return .piece
            default: return .package
            }
        }
        let newStock = Item.Stock(amount: amount, type: unit)
        delegate?.item(addStockAt: selectedIndex!, newStock: newStock)
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

