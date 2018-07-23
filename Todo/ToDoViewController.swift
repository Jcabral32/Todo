//
//  ViewController.swift
//  Todo
//
//  Created by Jean Cabral on 7/23/18.
//  Copyright © 2018 Jean Cabral. All rights reserved.
//

import UIKit

class ToDoViewController: UITableViewController {

    //MARK: New item Added
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new TODO item", message:"", preferredStyle: .alert)
        
        var mytextfield = UITextField()
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            print("Succes if Alert workds")
            self.itemArray.append(mytextfield.text!)
            self.tableView.reloadData()// Refreshes the tableview to reflect new data added to arry.
            
        }
        
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create New Item"
            mytextfield = textfield
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    var itemArray = ["item1", "item2", "item3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
    // Returns a Cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    // MARK: TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       // print(itemArray[indexPath.row])
      
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            
        tableView.cellForRow(at: indexPath)?.accessoryType = .none
            
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


}

