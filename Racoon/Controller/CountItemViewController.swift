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
    @IBOutlet weak var editButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        saveButton.layer.cornerRadius = saveButton.frame.size.height / 2
        editButton.layer.cornerRadius = editButton.frame.size.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = selectedItem.name
    }
    
    @IBAction func saveButtonClicked(_ sender: UIButton) {
        print("saved Item \(selectedItem)")
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editButtonClicled(_ sender: UIButton) {
        //go to edit page or pop up editing options
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
