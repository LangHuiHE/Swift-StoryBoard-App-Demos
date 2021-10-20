//
//  ItemStore.swift
//  Project 2
//
//  Created by LangHui on 10/17/21.
//

import UIKit

class ItemStore {
    var allItems = [Item]()
    
    init() {
        do {
                let data = try Data(contentsOf: itemArchiveURL)
                let unarchiver = PropertyListDecoder()
                let items = try unarchiver.decode([Item].self, from: data)
                allItems = items
        } catch {
            print("Reading in saved items: \(error)")
        }
            
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self,
                                       selector: #selector(saveChanges),
                                       name: UIScene.didEnterBackgroundNotification,
                                       object: nil)
    }
    
    let itemArchiveURL: URL = {
        let documentsDirectories =
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("items.plist")
    }()
    

    
    @objc func saveChanges() -> Bool {
        print("Saving items to: \(itemArchiveURL)")
        
        do {
                let encoder = PropertyListEncoder()
                // let data = encoder.encode(allItems)
                let data = try encoder.encode(allItems)
                try data.write(to: itemArchiveURL, options: [.atomic])
                        print("Saved all of the items")
                        return true
            
            } catch let encodingError {
                print("Error encoding allItems: \(encodingError)")
                return false
            }

    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        
        allItems.append(newItem)
        
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
    }
    
    func moveItem(from fromIndex: Int, to toIndex: Int) {
        if fromIndex == toIndex {
            return
        }

        // Get reference to object being moved so you can reinsert it
        let movedItem = allItems[fromIndex]

        // Remove item from array
        allItems.remove(at: fromIndex)

        // Insert item in array at new location
        allItems.insert(movedItem, at: toIndex)
    }
}
