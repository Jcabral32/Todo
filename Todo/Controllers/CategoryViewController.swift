//
//  CategoryViewController.swift
//  Todo
//
//  Created by Jean Cabral on 8/7/18.
//  Copyright © 2018 Jean Cabral. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {

    
    var categoryArray = [Category]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadItems()
    }


    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "Add", message: "New Category", preferredStyle: .alert)
        
        var myTextField = UITextField()
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            
            newCategory.name = myTextField.text!
        
            self.categoryArray.append(newCategory)
            self.saveItems()
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Create new Category"
            myTextField = textfield
        }
        
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
        return categoryArray.count
    }
    
    //MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = categoryArray[indexPath.row].name
        //let category = categoryArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //categoryArray[indexPath.row].name
        
        performSegue(withIdentifier: "goToItems", sender: self)
        
      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVc = segue.destination as! ToDoViewController
        
        if let indexPath = tableView.indexPathForSelectedRow{
            destinationVc.selectedCategory = categoryArray[indexPath.row]
        }
    }
    
    
    //MARK: Data Manipulation Methods

    func saveItems(){
        do{
            try context.save()
        }catch{
            print("If there is an Error here it is: \(error)")
        }
        self.tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Category> = Category.fetchRequest()){
        
        do{
            categoryArray = try context.fetch(request)
        }catch{
            print("If there are any errors here they are \(error)")
        }
        tableView.reloadData()
    }
    
    func removeItems(indexToRemove: Int){
        context.delete(categoryArray.remove(at: indexToRemove))
        categoryArray.remove(at: indexToRemove)
        do{
            try context.save()
        }catch{
            print("There was an error deleting an item \(error)")
        }
    }
   
    
    
    
    
}
