//
//  DatabaseService.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 21/03/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

/*
 Singleton declaration of the database interaction.
 It avoids doing several saves and retrieves at the same time
 */


class DatabaseService {
    static let shared = DatabaseService()
    
    private init() {
        
    }
    
    func retrieveListInDatabase() -> [XmlTags] {
        var itemsFromDatabase: [XmlTags] = []
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    var xmlTag = XmlTags(title: "", persons: "", description: "", room: "", start: "", duration: "", idTalk: "")
                    if let talkTitle = result.talkTitle {
                        xmlTag.title = talkTitle
                    }
                    if let person = result.person {
                        xmlTag.persons = person
                    }
                    if let descriptiontalk = result.descriptiontalk {
                        xmlTag.description = descriptiontalk
                    }
                    if let start = result.start {
                        xmlTag.start = start
                    }
                    if let room = result.room {
                        xmlTag.room = room
                    }
                    if let duration = result.duration {
                        xmlTag.duration = duration
                    }
                    if let idTalk = result.idTalk {
                        xmlTag.idTalk = idTalk
                    }
                    itemsFromDatabase.append(xmlTag)
                }
            } catch {
                print("Could not retrieve")
            }
        }
        return itemsFromDatabase
    }
    
    func save(xmlItem: XmlTags) {
        /*
         Save item to core data. The item has to exist when arriving this stage
         */
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites",
                                                                     in: context) else {return }
            let newValue = NSManagedObject(entity: entityDescription,
                                           insertInto: context)
            newValue.setValue(xmlItem.title, forKey: "talkTitle")
            newValue.setValue(xmlItem.persons, forKey: "person")
            newValue.setValue(xmlItem.duration, forKey: "duration")
            newValue.setValue(xmlItem.start, forKey: "start")
            newValue.setValue(xmlItem.room, forKey: "room")
            newValue.setValue(xmlItem.description, forKey: "descriptiontalk")
            newValue.setValue(xmlItem.idTalk, forKey: "idTalk")
            
            do {
                try context.save()
                //print("Saved")
            } catch {
                print("Saving error")
            }
        }
    }
    
    func itemInDatabase(xmlItem: XmlTags) -> Bool {
        /*
         check it the item already exists in the database
         */
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    //print("doing it")
                    if let idTalk = result.idTalk {
                        if xmlItem.idTalk == idTalk {
                            return true
                        }
                    }
                }
            } catch {
                return false
            }
        }
        return false
    }
    
    func deleteItem(item xmlItem: XmlTags) {
        /*
         delete item from the database if it exists
         */
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    if xmlItem.idTalk == result.idTalk {
                        context.delete(result)
                    }
                }
            } catch {
                print("Could not delete object")
            }
            
            // after deleting you need to save the context
            // so that it is saved in the database
            do {
                try context.save()
            } catch {
                print("Could not save data")
            }
        }
    }
}
