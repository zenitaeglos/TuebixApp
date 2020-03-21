//
//  DataSource.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import Foundation


class DataSource {
    static let shared = DataSource()
    
    private let BASE_URL = "https://www.tuebix.org/"
    private let extensionUrl = "/giggity.xml"
    
    private let years = ["2019", "2018", "2017", "2016", "2015"]
    
    func getGithubUrl() -> String {
        return "https://github.com/zenitaeglos/TuebixApp"
    }
    
    func getBaseUrl() -> String {
        return BASE_URL
    }
    
    func lastConference() -> String {
        return BASE_URL + years[0] + extensionUrl
    }
    
    func allYearsConferences() -> [String] {
        return years
    }
    
    func getYearConference(year yearConference: String) -> String {
        if self.years.contains(yearConference) {
            return self.BASE_URL + yearConference + self.extensionUrl
        }
        return String()
    }
    
    func getYearByPosition(position element: Int) -> String {
        if element < years.count && element > -1 {
            return self.years[element]
        }
        return self.years[self.years.count - 1]
    }
}
