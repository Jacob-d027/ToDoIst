//
//  ToDoList.swift
//  ToDoist
//
//  Created by Jacob Davis on 12/13/23.
//

import Foundation

extension ToDoList {
    public var itemsArray: [Item] {
        let set = items as? Set<Item> ?? []
        return Array(set)
    }
}
