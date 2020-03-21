//
//  FavoritesConferenceTableViewCell.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 23/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class FavoritesConferenceTableViewCell: UITableViewCell {

    @IBOutlet weak var tittleConferenceLabel: UILabel!
    @IBOutlet weak var personConferenceLabel: UILabel!
    @IBOutlet weak var startConferenceLabel: UILabel!
    @IBOutlet weak var roomConferenceLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAttributes(xmlAttributes: XmlTags) {

        tittleConferenceLabel.text = xmlAttributes.title
        personConferenceLabel.text = xmlAttributes.persons
        startConferenceLabel.text = "Starts: \(xmlAttributes.start)"
        roomConferenceLabel.text = "Room: \(xmlAttributes.room)"
    }

}
