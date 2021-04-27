//
//  CountItemViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class CountItemViewController: UIViewController {
    
    var selectedItem: Item
    var isEditingStock: Bool = false
    var selectedStockIndex = 0
    var delegate: ItemDelegate?
    
    init?(coder: NSCoder, selectedItem: Item) {
        self.selectedItem = selectedItem
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an item.")
    }

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var detailtemTableView: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailtemTableView.delegate = self
        detailtemTableView.dataSource = self
        
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = selectedItem.name
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        isEditingStock = false
        self.showDetailViewController(configureInventoryVC(), sender: self)
        detailtemTableView.reloadData()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        //somehow make manager to update selectedItem here
        navigationController?.popViewController(animated: true)
    }
    
    func configureInventoryVC() -> UIViewController {
        let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryControllerID") as! InventoryController
        let navigationC = UINavigationController(rootViewController: inventoryVC)
        inventoryVC.delegate = self
        inventoryVC.navigationItem.title = self.isEditingStock ? "Edit Stock" : "Add Stock"
        return navigationC
    }
}

//MARK: - UITableViewDelegate
extension CountItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isEditingStock = true
        self.selectedStockIndex = indexPath.row
        self.showDetailViewController(configureInventoryVC(), sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            self.selectedItem.inventory.remove(at: indexPath.row)
            self.detailtemTableView.deleteRows(at: [indexPath], with: .automatic)
            print(self.selectedItem.inventory)
        }
        let actions = UISwipeActionsConfiguration(actions: [delete])
        return actions
    }
}

//MARK: - UITableViewDataSource
extension CountItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedItem.inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath)
        let inventory = selectedItem.inventory[indexPath.row]
        cell.textLabel?.text = "\(inventory.amount)"
        cell.detailTextLabel?.text = "\(inventory.type)"
        return cell
    }
}

//MARK: - CreateNewStockDelegate
extension CountItemViewController: ItemDelegate {
    func updateViewWithNewStock(stock: Item.Inventory) {
        self.dismiss(animated: true) {
            if self.isEditingStock == false {
                self.selectedItem.inventory.append(stock)
            } else {
                self.selectedItem.inventory[self.selectedStockIndex] = stock
            }
            self.detailtemTableView.reloadData()
        }
    }
}
