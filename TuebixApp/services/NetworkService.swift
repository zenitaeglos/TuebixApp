//
//  NetworkService.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 18/01/2020.
//  Copyright © 2020 Alejandro Martinez Montero. All rights reserved.
//

import Foundation

//MARK: NetworkServiceDelegate

/*
 Delegation pattern. As network works in another thread,
 NetworkServiceDelegate works as signal to the implemented class
 to when it is finished and what to do with the results
 */

protocol NetworkServiceDelegate {
    func didReceiveData(_ dataFetched: [XmlTags])
    func didOcurrErrorInRetrieving(_ error: String)
}

//MARK: NetworkService

class NetworkService {
    /*
     Network class for retrieving data.
     doing a template design pattern
     */
    
    // delegation of the implementation leaved to the class which needs networking
    var delegate: NetworkServiceDelegate?
    
    func getConferences(url xmlUrl: String) {
        /*
         given a url it retrieves all xml data and then lets the delegate implements its actions
         */
        let request = URLRequest(url: URL(string: xmlUrl)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                guard let data = data, let response = response as? HTTPURLResponse else {
                    if let error = error {
                        self.delegate?.didOcurrErrorInRetrieving(error.localizedDescription)
                    }
                    return
                }
                if response.statusCode == 200 {
                    let parser = FeedParser(data: data)
                    self.delegate?.didReceiveData(parser.getXml())
                }
                else {
                    self.delegate?.didOcurrErrorInRetrieving("no 200")
                }
            }
        }
        task.resume()
    }
}
