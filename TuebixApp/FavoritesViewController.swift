//
//  FavoritesViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 04/07/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

class FavoritesViewController: UIViewController {

    private var xmlItems: [XmlTags] = []
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        self.xmlItems.removeAll()
        retrieveValues()
        tableView.reloadData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.xmlItems.removeAll()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewDidAppear(_ animated: Bool) {
        self.xmlItems.removeAll()
        retrieveValues()
        tableView.reloadData()
    }

}


extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell") as? FavoritesTableViewCell else {
            return UITableViewCell()
        }
        let item = xmlItems[indexPath.row]
        cell.setAttributes(xmlAttributes: item)
        return cell
    }
    
    
}


extension FavoritesViewController {
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
        tableView.reloadData()
    }
}
