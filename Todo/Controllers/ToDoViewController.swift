//
//  ViewController.swift
//  Todo
//
//  Created by Jean Cabral on 7/23/18.
//  Copyright © 2018 Jean Cabral. All rights reserved.
//

import UIKit


class ToDoViewController: UITableViewController {

// MARK: Properties
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(dataFilePath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK: Add New Item
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new TODO item", message:" ", preferredStyle: .alert)
       
        var mytextfield = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Success! Alert Works.")
            let newItem = Item()
            newItem.title = mytextfield.text!
            newItem.title = mytextfield.text!
            self.itemArray.append(newItem)
            self.saveItems()
            self.tableView.reloadData()// Refreshes the tableview to reflect new data added to arry.
        }
            alert.addTextField { (textfield) in
                textfield.placeholder = "Create New Item"
                mytextfield = textfield
            
            }
        alert.addAction(action)
        
        
        self.present(alert, animated: true, completion: nil)
        
        }

        
//MARK: Model Manipulation Methods
    
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(self.itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error enocidng item array.")
        }
    }
    
// MARK: TableView Data Source Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
// Cell Appearance
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        let item = itemArray[indexPath.row]
        cell.accessoryType = item.isChecked ? .checkmark : .none
        return cell
    }
    
// MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            itemArray[indexPath.row].isChecked = !itemArray[indexPath.row].isChecked
            saveItems()
            tableView.reloadData()
            tableView.deselectRow(at: indexPath, animated: true)
    }
}


