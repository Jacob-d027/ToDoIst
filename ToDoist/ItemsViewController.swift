//
//  ViewController.swift
//  ToDoist
//
//  Created by Parker Rushton on 10/15/22.
//

import UIKit

class ItemsViewController: UIViewController {
    
    init?(coder:NSCoder, list: ToDoList) {
        self.list = list
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    enum TableSection: Int, CaseIterable {
        case incomplete, complete
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    // MARK: - Properties
    
    private let itemManager = ItemManager.shared
    let list: ToDoList
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

}


// MARK: - Private

private extension ItemsViewController {
    
    func item(at indexPath: IndexPath) -> Item {
        let tableSection = TableSection(rawValue: indexPath.section)!
        switch tableSection {
        case .incomplete:
            return itemManager.fetchIncompleteItems(for: list)[indexPath.row]
        case .complete:
            return itemManager.fetchCompletedItems(for: list)[indexPath.row]
        }
    }
    
//    func refreshData(reload: Bool = true) {
//         = list.itemsArray.filter { $0.isCompleted }.sorted { $0.createdAtDate < $1.createdAtDate }
//        let completed = list.itemsArray.filter { $0.isCompleted }
//        let completedSorted = completed.sorted { first, second in
//            guard let firstCompleted = first.completedAt, let secondCompleted = second.completedAt else { return false }
//            return firstCompleted < secondCompleted
//        }
//        = completedSorted
//        tableView.reloadData()
//    }
    
}


// MARK: - TableView DataSource

extension ItemsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let tableSection = TableSection(rawValue: section)!
        switch tableSection {
        case .incomplete:
            return "To-Do (\(list.itemsArray.count))"
        case .complete:
            return "Completed (\(list.itemsArray.count))"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        TableSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let tableSection = TableSection(rawValue: section)!
        switch tableSection {
        case .incomplete:
            return itemManager.fetchIncompleteItems(for: list).count
        case .complete:
            return itemManager.fetchCompletedItems(for: list).count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: ItemTableViewCell.reuseIdentifier) as! ItemTableViewCell
        let item = item(at: indexPath)
        cell.update(with: item)
        return cell
    }

    
    // Swipe to Delete
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        itemManager.remove(item(at: indexPath))
        tableView.reloadData()
    }
    
}

// MARK: - TableView Delegate

extension ItemsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = item(at: indexPath)
        itemManager.toggleItemCompletion(item)
        tableView.reloadData()
    }
    
}


// MARK: - TextField Delegate

extension ItemsViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return true }
        itemManager.createNewItem(with: text, list: list)
//        refreshData()
        tableView.reloadSections([TableSection.incomplete.rawValue], with: .automatic)
        textField.text = ""
        return true
    }
    
    
    
}
