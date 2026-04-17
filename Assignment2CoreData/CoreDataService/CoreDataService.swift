//
//  CoreDataService.swift
//  Assignment2CoreData
//
//  Created by James Faloon on 2026-04-17.
//

import Foundation
import CoreData
import UIKit

public final class CoreDataService {
    
    static let shared = CoreDataService();
    
    // 1. Define the property properly
    private let context: NSManagedObjectContext
    
    var items :[Message]?
    
    private init() {
        // 2. Assign the context from the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.context = appDelegate.persistentContainer.viewContext
        print("Got Data Context")
    }

    
    func fetchData() -> [Message]? {
        do {
            self.items = try context.fetch(Message.fetchRequest())
            return self.items;
        } catch {
            print("Failed to fetch items ");
            return []
        }
             
    }
    
    
    func createTestData() {
        print("Adding Test Data");
        let service = CoreDataService.shared
        service.createMessage(text: "Test Message 1")
        service.createMessage(text: "Test Message 2")
        // Then call your load function to refresh the table
        CoreDataService.shared.saveContext()
    }
    
    
    func createMessage(text : String) {
        let newMessage = Message(context : self.context,)
        newMessage.message = text;
        
        CoreDataService.shared.saveContext()

        
    }
    
    
    func saveContext() {
        do {
            try self.context.save()
        } catch {
            print("couldn't save context ")
            
        }
        
    }
    
    
    func deleteMessage(id : UUID)
    {
        let messageToRemove = self.items?.first(where: { $0.id == id } )
        
        if (messageToRemove == nil) {
            print("couldn't find message");
            
        } else {
            self.context.delete(messageToRemove!);
        }
              
        CoreDataService.shared.saveContext();
    }
    
    
    
    
}
