//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var dataArray: [Item] = [
        Item(name: "Bacon Kg", quantity: 100, unit: .kg),
        Item(name: "Fish Can 250g", quantity: 50, unit: .piece),
        Item(name: "Patty pcs", quantity: 100, unit: .piece),
        Item(name: "Not Counted Item", quantity: 0, unit: .kg)
    ]
    
    var items: [Item] = []
    
    let searchBar = UISearchBar(frame: CGRect.zero)
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        searchBar.delegate = self
        items = dataArray
        configureSearchBar()
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
    
    func configureSearchBar() {
        searchBar.placeholder = "Search"
        navigationItem.titleView = searchBar
        searchBar.isHidden = true
        searchBar.showsCancelButton = true
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            items = dataArray
            itemsTableView.reloadData()
        case 1:
            items = dataArray
            items = items.filter { $0.quantity != 0 }
            itemsTableView.reloadData()
        case 2:
            items = dataArray
            items = items.filter { $0.quantity == 0 }
            itemsTableView.reloadData()
        default:
            break
        }
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
        cell.detailTextLabel?.text = "\(items[indexPath.row].quantity) \(items[indexPath.row].unit)"
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
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, nil) in
            print("Delete")
        }
        delete.image = UIImage(systemName: "xmark")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}

//MARK: - UISearchBar Delegate
extension MainPageViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        items = dataArray
        itemsTableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        segmentedSwitch.selectedSegmentIndex = 0
        items = dataArray
        itemsTableView.reloadData()
        if searchBar.text?.count == 0 {
            itemsTableView.reloadData()
        } else {
            let searchString = searchText.capitalized
            items = items.filter { $0.name.contains(searchString) }
            itemsTableView.reloadData()
        }
    }
}

//MARK: - CreateItemDelegate
extension MainPageViewController: CreateItemDelegate {
    func updateViewWithNewItem(item: Item) {
        self.dismiss(animated: true) {
            self.dataArray.append(item)
            self.items = self.dataArray
            self.itemsTableView.reloadData()
        }
    }
}


