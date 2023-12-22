//
//  ListOfListsTableViewController.swift
//  ToDoist
//
//  Created by Jacob Davis on 12/14/23.
//

import UIKit

class ListOfListsTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var listOfLists: [ToDoList] = []
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshListData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        refreshListData()
    }
    
    // MARK: Funcs
    
    @IBAction func addList(_ sender: Any) {
        addListUIController()
        refreshListData()
    }
    
    func addListUIController() {
        let alertController = UIAlertController(title: "New List", message: "", preferredStyle: .alert)
        
        // add textfield for input
        alertController.addTextField { (textField: UITextField!) -> Void in
            textField.placeholder = "Enter Name For List Here"
        }
        
        // save button to save info and create a new list
        let saveAction = UIAlertAction(title: "Save", style: .default) { alert -> Void in
            if let textField = alertController.textFields?[0] {
                if let title = textField.text {
                    ItemManager.shared.createNewList(with: title)
                    if let newList = ItemManager.shared.allLists.last {
                        self.listOfLists.append(newList)
                    }
                }
                self.refreshListData()
            }
        }
        
        // cancel action
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func list(at indexPath: IndexPath) -> ToDoList {
        ItemManager.shared.getAllLists()[indexPath.row]
    }
    
    func refreshListData() {
        listOfLists = ItemManager.shared.getAllLists()
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        ItemManager.shared.removeToDoList(indexPath)
        refreshListData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        let list = listOfLists[indexPath.row]
        
        //         Configure the cell...
        var content = cell.defaultContentConfiguration()
        content.text = list.title
        content.secondaryText = "Number of Items: \(list.itemsArray.count)"
        cell.contentConfiguration = content
        
        return cell
    }
    
    
    
    @IBSegueAction func showItems(coder: NSCoder, sender: Any?, segueIdentifier: String) -> ItemsViewController? {
        guard let indexPath = tableView.indexPathForSelectedRow else {
            return nil
        }
        
        // deselect row
        tableView.deselectRow(at: indexPath, animated: true)
        
        //initialized new item view controller
        print(listOfLists[indexPath.row])
        return ItemsViewController(coder: coder, list: listOfLists[indexPath.row])
    }
}
