//
//  CountItemViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class CountItemViewController: UIViewController {
    
    var selectedItem: Item
    
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
        selectedItem.inventory.append(1)
        detailtemTableView.reloadData()
    }
    
    
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        print("saved Item \(selectedItem)")
        navigationController?.popViewController(animated: true)
    }
}

extension CountItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let inventoryVC = storyboard?.instantiateViewController(identifier: "InventoryControllerID") as! InventoryController
        self.showDetailViewController(inventoryVC, sender: self)
    }
}

extension CountItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        selectedItem.inventory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "InventoryCell", for: indexPath)
        cell.textLabel?.text = "\(selectedItem.inventory[indexPath.row])"
        cell.detailTextLabel?.text = "kg"
        return cell
    }
}
