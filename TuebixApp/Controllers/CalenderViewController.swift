//
//  CalenderViewController.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import UIKit

//MARK: - CalenderViewController

class CalenderViewController: UIViewController {
    
    private var networkService: NetworkService = NetworkService()

    private var xmlItems: [XmlTags]?
    private var currentxmlItems: [XmlTags]?
    
    private var sectionsList: [String] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var talksTableView: UITableView!
    @IBOutlet weak var yearConferenceTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.networkService.delegate = self
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
        self.networkService.getConferences(url: yearChosen)
        /*
        NetworkService.shared.getConferences(url: yearChosen, onSuccess: { (xmlItems) in
            self.setSectionsHeader(xmlitems: xmlItems)
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
        
        */
    }
    
    func createYearPicker() {
        /*
         
         */
        let yearPicker = UIPickerView()
        yearPicker.delegate = self
        yearConferenceTextField.inputView = yearPicker
    }
    
    func setSectionsHeader(xmlitems: [XmlTags]) {
        /*
         fill the sectionlist with the section headers of the fetch data
         */
        self.sectionsList = []
        for item in xmlitems {
            if !self.sectionsList.contains(item.room) {
                self.sectionsList.append(item.room)
            }
        }
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


//MARK: - NetworkServiceDelegate

extension CalenderViewController: NetworkServiceDelegate {
    func didReceiveData(_ dataFetched: [XmlTags]) {
        self.setSectionsHeader(xmlitems: dataFetched)
        self.xmlItems = dataFetched
        self.currentxmlItems = dataFetched
        self.talksTableView.reloadData()
    }
    
    func didOcurrErrorInRetrieving(_ error: String) {
        let alert = UIAlertController(title: "Something went wrong", message: "We could not retrieve the data, the server might be down", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default, handler: { _ in
        NSLog("The \"OK\" alert occured.")
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}

//MARK: - UITableViewDelegate, UITAbleViewDataSource

extension CalenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let xmlItems = self.currentxmlItems else {
            return 0
        }
        var counter = 0
        
        for item in xmlItems {
            if item.room == self.sectionsList[section] {
                counter += 1
            }
        }

        return counter
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PresentationCell") as? PresentationTableViewCell else {
            return UITableViewCell()
        }
        
        var currentSectionItems: [XmlTags] = []
        
        if self.currentxmlItems != nil {
            for item in self.currentxmlItems! {
                if item.room == self.sectionsList[indexPath.section] {
                    currentSectionItems.append(item)
                }
            }
        }
        
        let item = currentSectionItems[indexPath.row]
        cell.setAttributes(xmlAttributes: item)
        
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionsList.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "TalkSegue", sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Room: " + self.sectionsList[section]
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

//MARK: - UISearchBarDelegate

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
