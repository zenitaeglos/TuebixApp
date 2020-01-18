//
//  AnfahrtViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 04/10/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class AnfahrtViewController: UIViewController {

    @IBOutlet weak var anfahrtLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        anfahrtLabel.textColor = .label
        anfahrtLabel.backgroundColor = .systemBackground
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
