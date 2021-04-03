//
//  ViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class MainPageViewController: UIViewController {
    
    var itemIndex: Int?
    
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEdit" {
            if let destinationVC = segue.destination as? CountItemViewController {
                if itemIndex != nil {
                    destinationVC.selectedItem = items[itemIndex!]
                } else {
                    print("itemindex is nil")
                }
            }
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
        itemIndex = indexPath.row
        if itemIndex != nil {
            print(items[itemIndex!].name)
        } else {
            print("itemindex is nil")
        }
    }
}

