//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit
import RealmSwift

class MainPageViewController: UIViewController {
    
    var manager = ItemManager.shared
    var itemsToken : NotificationToken?
    lazy var items: Results<Item> = manager.getData()

    var filteredItems: [Item] {
        get {
            return items.toArray()
        } set {
            DispatchQueue.main.async {
                self.itemsTableView.reloadData()
            }
        }
    }
    
    //MARK: Searchbar Boolen Properties
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = true
        
//      MARK: - Realm Notification Token
        itemsToken = manager.dataArray.observe { changes in
            guard let tableView = self.itemsTableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        //MARK: - UISearchController's parameters at viewDidLoad
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
        filterContentForSearchText("")
        searchController.searchBar.scopeButtonTitles = Item.Category.allCases.map { $0.rawValue }
        searchController.searchBar.delegate = self

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        let resetButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(handleReset))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem = resetButton
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        itemsToken?.invalidate()
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
        filteredItems.filter { (item: Item) -> Bool in
            let doesCategoryMatch = category == .all || item.category == category

            if isSearchBarEmpty {
                return doesCategoryMatch
            } else {
                return doesCategoryMatch && item.name.lowercased().contains(searchText.lowercased())
//                return doesCategoryMatch && items.filter("name CONTAINS[cd] %@", searchText).sorted(byKeyPath: "name", ascending: true)
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
        var unit: String {
            switch item.unit {
            case .kg: return "Grams"
            case .piece: return "Pieces"
            }
        }
        cell.detailTextLabel?.text = "\(item.totalStock.clean) \(unit)"
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
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        //MARK: - Delete Action
//        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, nil) in
//            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
//                manager.deleteItem(at: indexPath.row)
//                tableView.deleteRows(at: [indexPath], with: .automatic)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
//                tableView.reloadRows(at: [indexPath], with: .right)
//            }))
//            self.present(alert, animated: true, completion: nil)
//        }
//        //MARK: - Edit Action
//        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, complete) in
//            let selectedItem = self.filteredItems[indexPath.row]
//            let editItemVC = self.storyboard?.instantiateViewController(identifier: "EditItemTableViewControllerID", creator: { coder in
//                return EditItemTableViewController(coder: coder, selectedItem: selectedItem, indexPath: indexPath.row)
//            })
//            let navigationC = UINavigationController(rootViewController: editItemVC!)
//            editItemVC?.delegate = self
//            self.showDetailViewController(navigationC, sender: self)
//            complete(true)
//        }
//        //MARK: - Reset Action
//        let reset = UIContextualAction(style: .normal, title: "Reset") { action, view, complete in
//            let selectedItem = self.filteredItems[indexPath.row]
//            self.manager.resetInventory(for: selectedItem)
//            self.itemsTableView.reloadRows(at: [indexPath], with: .right)
//        }
//        delete.image = UIImage(systemName: "xmark")
//        edit.image = UIImage(systemName: "square.and.pencil")
//        edit.backgroundColor = .purple
//        reset.image = UIImage(systemName: "arrow.clockwise")
//        reset.backgroundColor = .link
//        return UISwipeActionsConfiguration(actions: [delete, edit, reset])
//    }
//  MARK: - TableView Editing Methos
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
                self.manager.deleteItem(at: indexPath.row)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { action in
                tableView.reloadRows(at: [indexPath], with: .none)
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

//MARK: - ItemDelegate
extension MainPageViewController: ItemDelegate { }

//https://www.raywenderlich.com/4363809-uisearchcontroller-tutorial-getting-started
//MARK: - UISearchResultsUpdating
extension MainPageViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
          let category = Item.Category(rawValue: searchBar.scopeButtonTitles![searchBar.selectedScopeButtonIndex])
          filterContentForSearchText(searchBar.text!, category: category)
        itemsTableView.reloadData()
    }
}

extension MainPageViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar,
      selectedScopeButtonIndexDidChange selectedScope: Int) {
    let category = Item.Category(rawValue: searchBar.scopeButtonTitles![selectedScope])
    filterContentForSearchText(searchBar.text!, category: category)
    itemsTableView.reloadData()
  }
}



