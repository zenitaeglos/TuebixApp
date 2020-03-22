//
//  TalkDescriptionViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 19/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit


class TalkDescriptionViewController: UIViewController {
    
    @IBOutlet weak var starButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var descriptionConferenceTextView: UITextView!
    @IBOutlet weak var titleConferenceLabel: UILabel!
    @IBOutlet weak var durationConferenceLabel: UILabel!
    @IBOutlet weak var startConferenceLabel: UILabel!
    var xmlItem: XmlTags?
    
    // shared database pointer
    let databaseService = DatabaseService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        self.titleConferenceLabel.text = xmlItem?.title
        self.durationConferenceLabel.text = "Duration: \(xmlItem?.duration ?? "")"
        self.startConferenceLabel.text = "Start: \(xmlItem?.start ?? "")"
        self.descriptionConferenceTextView.text = xmlItem?.description
        
        if let item = self.xmlItem {
            if databaseService.itemInDatabase(xmlItem: item) {
                starButtonItem.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // set button to default, as it is its default look
        starButtonItem.image = UIImage(systemName: "star")
        //check if it is necessary to change icon if it is in core date
        if let item = self.xmlItem {
            if databaseService.itemInDatabase(xmlItem: item) {
                starButtonItem.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    @IBAction func saveToFavoritesButtonItemClicked(_ sender: UIBarButtonItem) {
        //check if it is already saved, otherwise delete the element and change
        // the icon look
        
        if let item = self.xmlItem {
            if databaseService.itemInDatabase(xmlItem: item) {
                databaseService.deleteItem(item: item)
                starButtonItem.image = UIImage(systemName: "star")
            }
            else {
                databaseService.save(xmlItem: item)
                starButtonItem.image = UIImage(systemName: "star.fill")
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIBarButtonItem) {
        let items = [self]
        
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.barButtonItem = sender as UIBarButtonItem
        present(activityViewController, animated: true)
    }
}

//MARK: - UIActivitiItemSource

extension TalkDescriptionViewController: UIActivityItemSource {
    
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
}
