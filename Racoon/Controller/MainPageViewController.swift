//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var manager = ItemManager.shared
    var dataArray: [Item] {
        get {
            manager.getData()
        }
    }
    var items: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
        }
    }
    
    let searchBar = UISearchBar(frame: CGRect.zero)
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.addObserver(observer: self)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        searchBar.delegate = self
        configureSearchBar()
        updateTableView(with: "")
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItems = [addButton, resetButton]
    }
    
// MARK: - Selectors
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
    }
    
    @objc func handleReset() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Reset All", style: .destructive, handler: { action in
            self.manager.resetInventory()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
            return
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func handleAddItem() {
        guard let createItemVC = self.storyboard?.instantiateViewController(identifier: "CreateItemTableViewControllerID", creator: { coder in
            return CreateItemTableViewController(coder: coder)
        }) else {
            fatalError("CreateItemTableViewController not found")
        }
        createItemVC.delegate = self
        self.navigationController?.pushViewController(createItemVC, animated: true)
    }
    
    func updateTableView(with query: String) {
        if searchBar.text?.count == 0 {
            items = dataArray
        } else {
            let searchString = query.capitalized
            let searchedItems = dataArray.filter { $0.name.contains(searchString) }
            switch segmentedSwitch.selectedSegmentIndex {
            case 0:
                items = searchedItems
            case 1:
                items = searchedItems.filter { $0.totalStock != 0 }
            case 2:
                items = searchedItems.filter { $0.totalStock == 0 }
            default:
                items = searchedItems
            }
        }
    }
    
    func configureSearchBar() {
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.alpha = 0
        searchBar.showsCancelButton = true
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        switch segmentedSwitch.selectedSegmentIndex {
        case 0:
            items = dataArray
        case 1:
            items = dataArray.filter { $0.totalStock != 0 }
        case 2:
            items = dataArray.filter { $0.totalStock == 0 }
        default:
            items = dataArray
        }
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        if self.searchBar.alpha == 1 {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.searchBar.alpha = 0
            } completion: { bool in
                self.searchBar.resignFirstResponder()
            }
        } else {
            UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                self.searchBar.alpha = 1
            } completion: { bool in
                self.searchBar.becomeFirstResponder()
            }
        }
    }
}

//MARK: - UITableView Delegate and DataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.detailTextLabel?.text = "\(items[indexPath.row].totalStock) \(items[indexPath.row].unit)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard let countItemVC = self.storyboard?.instantiateViewController(identifier: "CountItemViewControllerID", creator: { coder in
            let inventoryVC = InventoryViewController(coder: coder, selectedItem: item, selectedIndex: indexPath.row)
            inventoryVC?.delegate = self
            return inventoryVC
        }) else {
            fatalError("CountItemViewController not found")
        }
        self.navigationController?.pushViewController(countItemVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //MARK: - Delete Action
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, nil) in
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                manager.deleteItem(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                tableView.reloadRows(at: [indexPath], with: .right)
            }))
            self.present(alert, animated: true, completion: nil)
        }
        //MARK: - Edit Action
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, complete) in
            let selectedItem = self.items[indexPath.row]
            let editItemVC = self.storyboard?.instantiateViewController(identifier: "EditItemTableViewControllerID", creator: { coder in
                return EditItemTableViewController(coder: coder, selectedItem: selectedItem, indexPath: indexPath.row)
            })
            let navigationC = UINavigationController(rootViewController: editItemVC!)
            editItemVC?.delegate = self
            self.showDetailViewController(navigationC, sender: self)
            complete(true)
        }
        delete.image = UIImage(systemName: "xmark")
        edit.image = UIImage(systemName: "square.and.pencil")
        edit.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}

//MARK: - UISearchBar Delegate
extension MainPageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        updateTableView(with: "")
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        segmentedSwitch.selectedSegmentIndex = 0
        itemsTableView.reloadData()
        updateTableView(with: searchText)
    }
}

//MARK: - ItemDelegate
extension MainPageViewController: ItemDelegate {
    func item(addItem item: Item) {
        manager.addItem(item)
        itemsTableView.reloadData()
    }
}

//MARK: - ItemManagerObserver
extension MainPageViewController: ItemManagerObserver {
    func didUpdateDataArray(to dataArray: [Item]) {
        items = dataArray
    }
}


