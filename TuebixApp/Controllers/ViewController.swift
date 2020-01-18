//
//  ViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 10/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    private var xmlItems: [XmlTags]?
    private var currentxmlItems: [XmlTags]?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var talksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        talksTableView.delegate = self
        talksTableView.dataSource = self
        searchBar.delegate = self
        searchBar.placeholder = "Search talk"
        
        fetchData(year: DataSource.shared.lastConference())
        
        //self.save(value: "c++")
        //self.save(value: "java shit")
        //self.save(value: "python bien")
        //self.deleteValue(title: "Boot Loader Spec + sd-boot")
        //self.retrieveValues()
    }
    //TODO set fetchdata in its own class
    // set function outside
    func fetchData(year yearChosen: String) {
        /*
        fetch all data from last conference
        */
        /*
        NetworkService.shared.getConferences(url: yearChosen, onSuccess: { (xmlItems) in
            self.xmlItems = xmlItems
            self.currentxmlItems = xmlItems
            self.talksTableView.reloadData()
        }) { (errorMessage) in
            
        }
        */
    }
    
    override func prepare(for segue:
        UIStoryboardSegue, sender: Any?) {
        searchBar.resignFirstResponder()
        
        if (segue.identifier == "DetailSegue") {
            let controller = segue.destination  as! TalkDetailsViewController
            let row = (sender as! IndexPath).row
            controller.xmlItem = currentxmlItems?[row]
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let xmlItems = currentxmlItems else {
            return 0
        }
        return xmlItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TalkTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = currentxmlItems?[indexPath.row] {
            cell.setAttributes(xmlAttributes: item)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
}


extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentxmlItems = xmlItems
            talksTableView.reloadData()
            return
        }
        currentxmlItems = xmlItems?.filter({ (XmlTags) -> Bool in
            XmlTags.title.lowercased().contains(searchText.lowercased())
        })
        talksTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}


extension ViewController {
    func save(value: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites",
                                                                     in: context) else {return }
            let newValue = NSManagedObject(entity: entityDescription,
                                           insertInto: context)
            newValue.setValue(value, forKey: "talkTitle")
            newValue.setValue("42", forKey: "person")
            
            do {
                try context.save()
                print("Saved \(value)")
            } catch {
                print("Saving error")
            }
        }
    }
    
    func retrieveValues() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            
            do {
                let results = try context.fetch(fetchRequest)
                
                for result in results {
                    if let talkTitle = result.talkTitle {
                        print(talkTitle)
                    }
                    if let person = result.person {
                        print(person)
                    }
                }
            } catch {
                print("Could not retrieve")
            }
            
            
        }
    }
    
    func deleteValue(title titleOfTalk: String) {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Favorites>(entityName: "Favorites")
            
            do {
                let results = try context.fetch(fetchRequest)
                for result in results {
                    if titleOfTalk == result.talkTitle {
                        context.delete(result)
                    }
                    else {
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
    }
}
