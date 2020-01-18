//
//  TalkDetailsViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 13/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import CoreData

class TalkDetailsViewController: UIViewController {
    
    var xmlItem: XmlTags?
    @IBOutlet weak var titleBarText: UINavigationItem!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var talkTitleLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        talkTitleLabel.text = xmlItem?.title
        descriptionTextView.text = xmlItem?.description
        titleBarText.title = "Room: --"
        if let titleName = xmlItem?.room {
            titleBarText.title = "Room: " + titleName
        }
        if let duration = xmlItem?.duration {
            durationLabel.text = "Duration: " + duration
        }
        if let startTime = xmlItem?.start {
            startTimeLabel.text = "Start: " + startTime
        }
    }
    
    override func viewDidLayoutSubviews() {
        descriptionTextView.setContentOffset(.zero, animated: false)
    }

    @IBAction func saveToCoreData(_ sender: Any) {
        save()
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


extension TalkDetailsViewController {
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
