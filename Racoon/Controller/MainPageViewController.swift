//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var dataArray: [Item] = [
        Item(name: "Bacon Kg", packageQuantity: 100, unit: .kg),
        Item(name: "Fish Can 250g", packageQuantity: 50, unit: .piece),
        Item(name: "Patty pcs", packageQuantity: 100, unit: .piece),
        Item(name: "Not Counted Item", packageQuantity: 0, unit: .kg),
        Item(name: "Item with Inventory", packageQuantity: 9, unit: .piece, inventory: [Item.Inventory(amount: 100, type: .package), Item.Inventory(amount: 18, type: .piece)])
    ]
    
    var items: [Item] = [] {
        didSet {
            itemsTableView.reloadData()
        }
    }
    
    let searchBar = UISearchBar(frame: CGRect.zero)
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        searchBar.delegate = self
        configureSearchBar()
        updateTableView(with: "")
        let tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MainPageViewController.dismissKeyboard))
        view.addGestureRecognizer(tapGestureRecognizer)
        tapGestureRecognizer.cancelsTouchesInView = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
    }
    
// MARK: - Selectors
    @objc func dismissKeyboard() {
        searchBar.resignFirstResponder()
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
                items = searchedItems.filter { $0.totalInventory != 0 }
            case 2:
                items = searchedItems.filter { $0.totalInventory == 0 }
            default:
                items = searchedItems
            }
        }
    }
    
    func configureSearchBar() {
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        //TODO: - Make segment filter work here
    }
    
    @IBAction func searchButtonPressed(_ sender: UIBarButtonItem) {
        searchBar.isHidden.toggle()
        if searchBar.isHidden == true {
            searchBar.text = ""
            searchBar.resignFirstResponder()
        } else {
            searchBar.becomeFirstResponder()
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
        cell.detailTextLabel?.text = "\(items[indexPath.row].totalInventory) \(items[indexPath.row].unit)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        guard let countItemVC = self.storyboard?.instantiateViewController(identifier: "CountItemViewControllerID", creator: { coder in
            return CountItemViewController(coder: coder, selectedItem: item)
        }) else {
            fatalError("CountItemViewController not found")
        }
        
        self.navigationController?.pushViewController(countItemVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { [self] (action, view, nil) in
            self.dataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
        let edit = UIContextualAction(style: .normal, title: "Edit") { (action, view, nil) in
            print("Edit")
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

//MARK: - CreateItemDelegate
extension MainPageViewController: CreateItemDelegate {
    func updateViewWithNewItem(item: Item) {
        self.dismiss(animated: true) {
            self.dataArray.append(item)
            self.itemsTableView.reloadData()
        }
    }
}


