//
//  TalkDescriptionViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 19/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

class TalkDescriptionViewController: UIViewController, UIActivityItemSource {
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return "Tuebix"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        if activityType == .postToTwitter {
            return "\(xmlItem?.title ?? "Tuebix Conference") #TuebixApp"
        }
        
        return "Vortrag: \(xmlItem?.title ?? "")\nPerson: \(xmlItem?.persons ?? "")\nRaum:\(xmlItem?.room ?? "")"
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return xmlItem?.title ?? "Tuebix"
    }
    
    
    @IBOutlet weak var starButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var descriptionConferenceTextView: UITextView!
    @IBOutlet weak var titleConferenceLabel: UILabel!
    @IBOutlet weak var durationConferenceLabel: UILabel!
    @IBOutlet weak var startConferenceLabel: UILabel!
    var xmlItem: XmlTags?
    
    // list of favorites from CoreData
    var xmlItems: [XmlTags] = []
    
    var indexPosition: Int = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.titleConferenceLabel.text = xmlItem?.title
        self.durationConferenceLabel.text = "Duration: \(xmlItem?.duration ?? "")"
        self.startConferenceLabel.text = "Start: \(xmlItem?.start ?? "")"
        self.descriptionConferenceTextView.text = xmlItem?.description
        self.xmlItems.removeAll()
        retrieveValues()
        
        // find if element is already in Core Data, change star button accordingly.
        var positionInCoreData = 0
        for favorite in self.xmlItems {
            let id = xmlItem?.idTalk
            if id == favorite.idTalk {
                starButtonItem.image = UIImage(systemName: "star.fill")
                self.indexPosition = positionInCoreData
            }
            positionInCoreData += 1
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.xmlItems.removeAll()
        retrieveValues()
        
        // set button to default, as it is its default look
        starButtonItem.image = UIImage(systemName: "star")
        //check if it is necessary to change icon if it is in core date
        var positionInCoreData = 0
        for favorite in self.xmlItems {
            let id = xmlItem?.idTalk
            if id == favorite.idTalk {
                starButtonItem.image = UIImage(systemName: "star.fill")
                self.indexPosition = positionInCoreData
            }
            positionInCoreData += 1
        }
    }
    
    @IBAction func saveToFavoritesButtonItemClicked(_ sender: UIBarButtonItem) {
        //check if it is already saved, otherwise delete the element and change
        // the icon look
        if starButtonItem.image == UIImage(systemName: "star.fill") {
            starButtonItem.image = UIImage(systemName: "star")
            //self.xmlItems.removeAll()
            //retrieveValues()
            deleteValues(index: self.indexPosition)
        }
        else {
            starButtonItem.image = UIImage(systemName: "star.fill")
            save()
            self.xmlItems.removeAll()
            retrieveValues()
            var positionInCoreData = 0
            for favorite in self.xmlItems {
                let id = xmlItem?.idTalk
                if id == favorite.idTalk {
                    starButtonItem.image = UIImage(systemName: "star.fill")
                    self.indexPosition = positionInCoreData
                }
                positionInCoreData += 1
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let items = [self]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        present(activityViewController, animated: true)
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


extension TalkDescriptionViewController {
    func save() {
        if let appDelegate = UIApplication.shared.delegate as? AppDelegate {
            let context = appDelegate.persistentContainer.viewContext
            
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "Favorites",
                                                                     in: context) else {return }
            let newValue = NSManagedObject(entity: entityDescription,
                                           insertInto: context)
            newValue.setValue(xmlItem?.title, forKey: "talkTitle")
            newValue.setValue(xmlItem?.persons, forKey: "person")
            newValue.setValue(xmlItem?.duration, forKey: "duration")
            newValue.setValue(xmlItem?.start, forKey: "start")
            newValue.setValue(xmlItem?.room, forKey: "room")
            newValue.setValue(xmlItem?.description, forKey: "descriptiontalk")
            newValue.setValue(xmlItem?.idTalk, forKey: "idTalk")
 
            do {
                try context.save()
                //print("Saved")
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
                    //print("doing it")
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
                        //print(idTalk)
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
    }
}
