//
//  EditItemTableViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 25.04.2021.
//

import UIKit

class EditItemTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var unitSegment: UISegmentedControl!
    @IBOutlet weak var quantityTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
