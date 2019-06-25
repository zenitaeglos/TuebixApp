//
//  TalkDetailsViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 13/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
