//
//  ItemManager.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/21/22.
//

import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()
    let context = PersistenceController.shared.viewContext
    var allItems = [Item]()
    var allLists = [ToDoList]()
    
    // Create
    
    func createNewItem(with title: String, list: ToDoList) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        newItem.list = list
        PersistenceController.shared.saveContext()
    }
    
    // Retrieve
    
    private func fetchItems(matching predicate: NSPredicate) -> [Item] {
        let fetchRequest = Item.fetchRequest()
        let sortDescriptor = [NSSortDescriptor(key: "completedAt", ascending: false), NSSortDescriptor(key: "createdAt", ascending: false)]
        
        fetchRequest.sortDescriptors = sortDescriptor
        fetchRequest.predicate = predicate
        do {
            let context = PersistenceController.shared.viewContext
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching items: \(error)")
            return []
        }
    }
    
    func fetchIncompleteItems(for list: ToDoList) -> [Item] {
        let incomplete = list.itemsArray.filter({ $0.completedAt == nil })
        return incomplete.sorted(by: { $0.createdAtDate > $1.createdAtDate })
    }
    
    func fetchCompletedItems(for list: ToDoList) -> [Item] {
        let completed = list.itemsArray.filter( { $0.isCompleted })
        return completed.sorted(by: { $0.createdAtDate > $1.createdAtDate })
    }
    
    
    // Update
    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
    }
    
    
    // Delete
    
    func remove(_ item: Item) {
        let context = PersistenceController.shared.viewContext
        context.delete(item)
        PersistenceController.shared.saveContext()
    }
    
    // MARK: ToDoList
    
    // Create
    func createNewList(with title: String) {
        let newList = ToDoList(context: PersistenceController.shared.viewContext)
        newList.id = UUID().uuidString
        newList.createdAt = Date()
        newList.title = title
        PersistenceController.shared.saveContext()
    }
    
    // Retrieve
    func getAllLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        let sortDescriptor = [NSSortDescriptor(key: "modifiedAt", ascending: false)]
        fetchRequest.sortDescriptors = sortDescriptor
        
        do {
            let context = PersistenceController.shared.viewContext
            return try context.fetch(fetchRequest)
        } catch {
            print("Error fetching ToDoList items: \(error)")
            return []
        }
    }
    
    // Delete
    func removeToDoList(_ indexPath: IndexPath) {
        let list = getAllLists()[indexPath.row]
        context.delete(list)
        PersistenceController.shared.saveContext()
    }
}
