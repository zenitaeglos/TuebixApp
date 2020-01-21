//
//  TalkDescriptionViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 19/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class TalkDescriptionViewController: UIViewController {

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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
