//
//  FavoritesConferencesViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 23/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

class FavoritesConferencesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    
    private var xmlItems: [XmlTags] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        self.xmlItems.removeAll()
        retrieveValues()
        favoritesTableView.reloadData()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.xmlItems.removeAll()
        retrieveValues()
        favoritesTableView.reloadData()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension FavoritesConferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteConferenceCell") as? FavoritesConferenceTableViewCell else {
            print("it does not find it")
            return UITableViewCell()
        }
        let item = xmlItems[indexPath.row]
        cell.setAttributes(xmlAttributes: item)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        deleteValues(index: indexPath.row)
    }


}


extension FavoritesConferencesViewController {
    func retrieveValues() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    print("doing it")
                    var xmlTag = XmlTags(title: "", persons: "", description: "", room: "", start: "", duration: "")
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
                    self.xmlItems.append(xmlTag)
                }
            } catch {
                print("Could not retrieve")
            }
        }
    }
    
    func deleteValues(index position: Int) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            do {
                let results = try context.fetch(fetchRequest)
                let xmlTag: XmlTags = xmlItems[position]
                for result in results {
                    if xmlTag.title == result.talkTitle {
                        context.delete(result)
                    }
                }
            } catch {
                print("Could not delete object")
            }
            
            do {
                try context.save()
            } catch {
                print("Could not save data")
            }
        }
        xmlItems.remove(at: position)
        favoritesTableView.reloadData()
    }
}

