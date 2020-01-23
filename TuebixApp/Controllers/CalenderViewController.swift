//
//  CalenderViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

class CalenderViewController: UIViewController {

    private var xmlItems: [XmlTags]?
    private var currentxmlItems: [XmlTags]?

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var talksTableView: UITableView!
    @IBOutlet weak var yearConferenceTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.searchBar.delegate = self
        self.searchBar.placeholder = "Search talk"
        self.talksTableView.delegate = self
        self.talksTableView.dataSource = self
        //fetch the current year data
        fetchData(year: DataSource.shared.lastConference())
        //setup pickerview with the element
        yearConferenceTextField.text = DataSource.shared.getYearByPosition(position: 0)
        createYearPicker()
        createToolBar()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func fetchData(year yearChosen: String) {
        /*
        fetch all data from last conference
        */
        NetworkService.shared.getConferences(url: yearChosen, onSuccess: { (xmlItems) in
            print(xmlItems.count)
            self.xmlItems = xmlItems
            self.currentxmlItems = xmlItems
            self.talksTableView.reloadData()
        }) { (errorMessage) in
            let alert = UIAlertController(title: "Something went wrong", message: "We could not retrieve the data, the server might be down", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
            NSLog("The \"OK\" alert occured.")
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func createYearPicker() {
        /*
         
         */
        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearConferenceTextField.inputView = yearPicker
    }
    
    func createToolBar() {
        /*
         
         */
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CalenderViewController.dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        yearConferenceTextField.inputAccessoryView = toolBar
    
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func prepare(for segue:
        UIStoryboardSegue, sender: Any?) {
        /*
         prepare for segue. TODO
         */
        /*
        searchBar.resignFirstResponder()
        */
        if (segue.identifier == "TalkSegue") {
            let controller = segue.destination  as! TalkDescriptionViewController
            let row = (sender as! IndexPath).row
            controller.xmlItem = currentxmlItems?[row]
        }
        
    }

}

extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let xmlItems = self.currentxmlItems else {
            return 0
        }
        return xmlItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentationCell") as? PresentationTableViewCell else {
            return UITableViewCell()
        }
    
        if let item = currentxmlItems?[indexPath.row] {
            cell.setAttributes(xmlAttributes: item)
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TalkSegue", sender: indexPath)
    }
    
}

extension CalenderViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataSource.shared.allYearsConferences().count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return DataSource.shared.getYearByPosition(position: row)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        yearConferenceTextField.text = DataSource.shared.getYearByPosition(position: row)
        fetchData(year: DataSource.shared.getYearConference(year: DataSource.shared.getYearByPosition(position: row)))
    }
}

extension CalenderViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            currentxmlItems = xmlItems
            talksTableView.reloadData()
            return
        }
        currentxmlItems = xmlItems?.filter({ (XmlTags) -> Bool in
            XmlTags.title.lowercased().contains(searchText.lowercased())
        })
        talksTableView.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.becomeFirstResponder()
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.endEditing(true)
    }

}
