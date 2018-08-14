//
//  ViewController.swift
//  Todo
//
//  Created by Jean Cabral on 7/23/18.
//  Copyright © 2018 Jean Cabral. All rights reserved.
//

import UIKit
import CoreData


class ToDoViewController: UITableViewController {

// MARK: Properties
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var selectedCategory : Category?{
        didSet{
            loadItems()
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        print(dataFilePath) 
        loadItems()
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
            // What happens when user clicks the Add Item button on our UIAlert
            let newItem = Item(context: self.context)
            newItem.title = mytextfield.text!
            newItem.isChecked = false
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
            self.saveItems()
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
        do{
            try context.save()
        }catch {
            print("If there is an Error here it is:\(error)")
        }
        self.tableView.reloadData()
    }
    
    
// Gets a specific request or (no param) deafult request which returns [] of Items.
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
        
        let cateogryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additonalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [cateogryPredicate, additonalPredicate])
        } else{
            request.predicate = cateogryPredicate
        }
       
        do{
            itemArray = try context.fetch(request)
        }catch{
            print("Error fetching data from Context \(error)")
        }
        tableView.reloadData()
    }
    
// Deletes Item From Core Data
    func removeItems(indexToRemove: Int){
        
        context.delete(itemArray.remove(at: indexToRemove))
        itemArray.remove(at: indexToRemove)
        do{
            try context.save()
        }catch{
            print("There was an error deleting an item \(error)")
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
            tableView.deselectRow(at: indexPath, animated: true)
    }
}

//MARK: SearchBar Section
extension ToDoViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        print(searchBar.text!)
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
    }
    
    
//  Restore Todo List to Original State
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // If there are no characters in search bar show the default list.
        if searchBar.text?.count == 0{
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()// No longer currently selected.
            }
        }
    }
    
}





