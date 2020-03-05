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
    
    
    

    @IBOutlet weak var descriptionConferenceTextView: UITextView!
    @IBOutlet weak var titleConferenceLabel: UILabel!
    @IBOutlet weak var durationConferenceLabel: UILabel!
    @IBOutlet weak var startConferenceLabel: UILabel!
    var xmlItem: XmlTags?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.titleConferenceLabel.text = xmlItem?.title
        self.durationConferenceLabel.text = "Duration: \(xmlItem?.duration ?? "")"
        self.startConferenceLabel.text = "Start: \(xmlItem?.start ?? "")"
        self.descriptionConferenceTextView.text = xmlItem?.description
        
    }
    
    @IBAction func saveToFavoritesButtonItemClicked(_ sender: UIBarButtonItem) {
        save()
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let items = [self]
        print(items)
        
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
 
            do {
                try context.save()
                print("Saved")
            } catch {
                print("Saving error")
            }
        }
    }
}
