//
//  InventoryViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class InventoryViewController: UIViewController {
    
    var manager = ItemManager.shared
        
    var selectedItem: Item {
        didSet {
            detailtemTableView.reloadData()
        }
    }
    
    var selectedIndex: Int
    var isEditingStock: Bool = false
    var selectedStockIndex = 0
    var delegate: ItemDelegate?
    
    init?(coder: NSCoder, selectedItem: Item, selectedIndex: Int) {
        self.selectedItem = selectedItem
        self.selectedIndex = selectedIndex
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You must create this view controller with an item.")
    }

    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var detailtemTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        detailtemTableView.delegate = self
        detailtemTableView.dataSource = self
        manager.addObserver(observer: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ItemManager.shared.observers.removeAll(where: { $0 is InventoryViewController })
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
    
    func configureInventoryVC() -> UIViewController {
        let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryControllerID") as! AddStockViewController
        let navigationC = UINavigationController(rootViewController: inventoryVC)
        inventoryVC.delegate = self
        inventoryVC.selectedIndex = selectedIndex
        inventoryVC.navigationItem.title = self.isEditingStock ? "Edit Stock" : "Add Stock"
        return navigationC
    }
}

//MARK: - UITableViewDelegate
extension InventoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isEditingStock = true
        self.selectedStockIndex = indexPath.row
        self.showDetailViewController(configureInventoryVC(), sender: self)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //MARK: - Delete Swipe
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            self.manager.deleteStock(at: self.selectedIndex, inventoryIndex: indexPath.row)
            self.detailtemTableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let actions = UISwipeActionsConfiguration(actions: [delete])
        return actions
    }
}

//MARK: - UITableViewDataSource
extension InventoryViewController: UITableViewDataSource {
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

//MARK: - ItemDelegate
extension InventoryViewController: ItemDelegate { }

//MARK: - ItemManagerObserver
extension InventoryViewController: ItemManagerObserver {
    func didUpdateDataArray(to dataArray: [Item]) {
        selectedItem = dataArray[selectedIndex]
    }
}
