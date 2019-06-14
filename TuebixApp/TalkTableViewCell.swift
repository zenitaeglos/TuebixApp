//
//  TalkTableViewCell.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 11/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class TalkTableViewCell: UITableViewCell {

    @IBOutlet weak var titleTalk: UILabel!
    @IBOutlet weak var personTalk: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    
    func setAttributes(xmlAttributes: XmlTags) {
        titleTalk.text = xmlAttributes.title
        personTalk.text = xmlAttributes.persons
        startTimeLabel.text = xmlAttributes.start
    }
    
    func setTitle(title: String) {
        titleTalk.text = title
    }

}
