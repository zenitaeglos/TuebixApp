//
//  InfoViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 21/03/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit
import SafariServices

class InfoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    @IBAction func tuebixPressed(_ sender: UIButton) {
        
        if let url = URL(string: DataSource.shared.getBaseUrl()) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            
            let safariViewController = SFSafariViewController(url: url, configuration: config)
            present(safariViewController, animated: true, completion: nil)
        }
    }
}
