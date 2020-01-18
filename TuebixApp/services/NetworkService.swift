//
//  NetworkService.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import Foundation


class NetworkService {
    static let shared = NetworkService()
    
    //let URL_BASE = "https://www.tuebix.org/2019/giggity.xml"
    
    //let session = URLSession(configuration: .default)
    
    func getConferences(url xmlUrl: String, onSuccess: @escaping ([XmlTags]) -> Void) {
            let feedParser = FeedParser()
            feedParser.parseFeed(url: xmlUrl) { (xmlItems) in
                DispatchQueue.main.async {
                    onSuccess(xmlItems)
                }
            }
        }
}
