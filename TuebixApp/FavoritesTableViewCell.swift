//
//  FavoritesTableViewCell.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 04/07/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    @IBOutlet weak var talkTitle: UILabel!
    @IBOutlet weak var person: UILabel!
    @IBOutlet weak var start: UILabel!
    @IBOutlet weak var duration: UILabel!
    @IBOutlet weak var room: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setAttributes(xmlAttributes: XmlTags) {
        print(xmlAttributes.start)
        print(xmlAttributes.title)
        talkTitle.text = xmlAttributes.title
        person.text = xmlAttributes.persons
        start.text = xmlAttributes.start
        duration.text = "Duration: " + xmlAttributes.duration
        room.text = "Room: " + xmlAttributes.room
    }
    
    func setTitle(title titleTalk: String) {
        talkTitle.text = titleTalk
    }

}
