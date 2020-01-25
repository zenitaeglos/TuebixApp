//
//  PresentationTableViewCell.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class PresentationTableViewCell: UITableViewCell {

    @IBOutlet weak var titlePresentationLabel: UILabel!
    @IBOutlet weak var personPresentationLabel: UILabel!
    @IBOutlet weak var startPresentationLabel: UILabel!
    @IBOutlet weak var roomPresentationLabel: UILabel!
    
    func setAttributes(xmlAttributes: XmlTags) {
        titlePresentationLabel.text = xmlAttributes.title
        personPresentationLabel.text = xmlAttributes.persons
        startPresentationLabel.text = "Starts: \(xmlAttributes.start)"
        roomPresentationLabel.text = "Room: \(xmlAttributes.room)"
    }

}
