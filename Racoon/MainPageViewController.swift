//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var dataArray: [Item] = [
        Item(name: "Bacon Kg", quantity: 100),
        Item(name: "Fish Can 250g", quantity: 50),
        Item(name: "Patty pcs", quantity: 100),
        Item(name: "Not Counted Item", quantity: 0)
    ]
    
    var items: [Item] = []
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var itemsTableView: UITableView!
    @IBOutlet weak var segmentedSwitch: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemsTableView.delegate = self
        itemsTableView.dataSource = self
        items = dataArray
        navigationItem.largeTitleDisplayMode = .always
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
    
}

extension MainPageViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemsCell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row].name
        cell.detailTextLabel?.text = "\(items[indexPath.row].quantity)"
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
        let delete = UIContextualAction(style: .destructive, title: "") { (action, view, nil) in
            print("Delete")
        }
        delete.image = UIImage(systemName: "xmark")
        return UISwipeActionsConfiguration(actions: [delete])
    }
}


