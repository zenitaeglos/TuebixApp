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
    
    func getConferences(url xmlUrl: String, onSuccess: @escaping ([XmlTags]) -> Void, onError: @escaping (String) -> Void) {
            let request = URLRequest(url: URL(string: xmlUrl)!)
            let urlSession = URLSession.shared
            let task = urlSession.dataTask(with: request) { (data, response, error) in
                DispatchQueue.main.async {
                    guard let data = data, let response = response as? HTTPURLResponse else {
                        if let error = error {
                            print(error.localizedDescription)
                            onError(error.localizedDescription)
                        }
                        return
                    }
                    if response.statusCode == 200 {
                        let parser = FeedParser(data: data)
                        onSuccess(parser.getXml())
                    }
                    else {
                        onError("no 200")
                    }
                }
            }
            task.resume()
        }
}