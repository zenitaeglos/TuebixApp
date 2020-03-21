//
//  FavoritesConferencesViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 23/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit


class FavoritesConferencesViewController: UIViewController {

    @IBOutlet weak var favoritesTableView: UITableView!
    @IBOutlet weak var noFavoritesLabel: UILabel!
    
    private var xmlItems: [XmlTags] = []
    
    // singleton database pointer
    let databaseService = DatabaseService.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favoritesTableView.delegate = self
        favoritesTableView.dataSource = self
        
        setListOfFavorites()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setListOfFavorites()
    }
    
    func setListOfFavorites() {
        /*
         retrieve the data from the database and initializr tableview and label
         */
        
        self.xmlItems = databaseService.retrieveListInDatabase()

        favoritesTableView.reloadData()
        
        if self.xmlItems.count == 0 {
            noFavoritesLabel.text = "You have no favorites yet"
            favoritesTableView.isHidden = true
        }
        else {
            noFavoritesLabel.text = ""
            favoritesTableView.isHidden = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        /*
         function for preparation for the next view controller
         */
        
        //favorites segue, send the item in the row
        if segue.identifier == "favoritesSegue" {
            let destinationViewController = segue.destination as! TalkDescriptionViewController
            let row = (sender as! IndexPath).row
            destinationViewController.xmlItem = self.xmlItems[row]
        }
    }
}

//MARK: -UITableViewDelegate, UITableViewDataSource

extension FavoritesConferencesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return xmlItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteConferenceCell") as? FavoritesConferenceTableViewCell else {
            return UITableViewCell()
        }
        let item = xmlItems[indexPath.row]
        cell.setAttributes(xmlAttributes: item)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        databaseService.deleteItem(item: self.xmlItems[indexPath.row])
        
        if !databaseService.itemInDatabase(xmlItem: self.xmlItems[indexPath.row]) {
            self.xmlItems.remove(at: indexPath.row)
            tableView.reloadData()
        }

        
        if self.xmlItems.count == 0 {
            noFavoritesLabel.text = "You have no favorites yet"
            favoritesTableView.isHidden = true
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "favoritesSegue", sender: indexPath)
    }
}

