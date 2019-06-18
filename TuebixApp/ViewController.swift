//
//  ViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 10/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var xmlItems: [XmlTags]?

    @IBOutlet weak var talksTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        talksTableView.delegate = self
        talksTableView.dataSource = self
        fetchData()
    }
    
    func fetchData() {
        let feedParser = FeedParser()
        feedParser.parseFeed(url: "https://www.tuebix.org/2019/giggity.xml") {
            (xmlItems) in
            self.xmlItems = xmlItems
            OperationQueue.main.addOperation {
                self.talksTableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "DetailSegue") {
            let controller = segue.destination  as! TalkDetailsViewController
            let row = (sender as! IndexPath).row
            controller.xmlItem = xmlItems?[row]
        }
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let xmlItems = xmlItems else {
            return 0
        }
        return xmlItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TalkTableViewCell else {
            return UITableViewCell()
        }
        
        if let item = xmlItems?[indexPath.row] {
            cell.setAttributes(xmlAttributes: item)
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "DetailSegue", sender: indexPath)
    }
}
