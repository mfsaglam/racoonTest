//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var manager = ItemManager.shared
    var items: [Item] {
        get {
            manager.getData()
        }
    }
    var filteredItems: [Item] = [] {
        didSet {
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
        }
    }
    
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        let searchBarScopeIsFiltering = searchController.searchBar.selectedScopeButtonIndex != 0
        return searchController.isActive && (!isSearchBarEmpty || searchBarScopeIsFiltering)
    }
    
    //MARK: - UISearchController's Parameters
    let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Items"
        return searchController
    }()
    
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager.addObserver(observer: self)
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        //MARK: - UISearchController's parameters at viewDidLoad
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        definesPresentationContext = true
        filterContentForSearchText("")
        searchController.searchBar.scopeButtonTitles = Item.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = resetButton
    }
    
// MARK: - Selectors
    
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
    
    func filterContentForSearchText(_ searchText: String, category: Item.Category? = nil) {
        filteredItems = items.filter { (item: Item) -> Bool in
            let doesCategoryMatch = category == .all || item.category == category
            
            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.name.lowercased()
                    .contains(searchText.lowercased())
            }
        }
    }
}

//MARK: - UITableView Delegate and DataSource
extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredItems.count
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        let item: Item
        if isFiltering {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
        cell.textLabel?.text = item.name
        cell.detailTextLabel?.text = "\(item.totalStock.clean) \(item.unit)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item: Item
        if isFiltering {
            item = filteredItems[indexPath.row]
        } else {
            item = items[indexPath.row]
        }
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
            let selectedItem = self.filteredItems[indexPath.row]
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
        filteredItems = dataArray
    }
}

//https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
//MARK: - UISearchResultsUpdating
extension MainPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
          let category = Item.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
          filterContentForSearchText(searchBar.text!, category: category)
    }
}

extension MainPageViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = Item.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
  }
}



