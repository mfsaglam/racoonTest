//
//  CreateItemViewController.swift
//  Racoon
//
//  Created by Fatih Sağlam on 30.03.2021.
//

import UIKit

class CreateItemViewController: UIViewController {
    
    let createArray: [CreateItemData] = [
        CreateItemData(settingName: "Item name", settingType: 0)
    ]

    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var createItemTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createItemTableView.delegate = self
        createItemTableView.dataSource = self
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

extension CreateItemViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return createArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "createItemCell", for: indexPath)
        cell.textLabel?.text = createArray[indexPath.row].settingName
        return cell
    }
    
    
}
