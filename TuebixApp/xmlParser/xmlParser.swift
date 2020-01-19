//
//  xmlParser.swift
//  TuebixApp
//
//  Created by Alejandro Martinez Montero on 10/06/2019.
//  Copyright © 2019 Alejandro Martinez Montero. All rights reserved.
//

import Foundation


struct XmlTags {
    var title: String
    var persons: String
    var description: String
    var room: String
    var start: String
    var duration: String
}


class FeedParser: NSObject, XMLParserDelegate {
    private var xmlItems: [XmlTags] = []
    private var currentElement: String = ""
    private var currentPerson: String = ""
    private var currentTitle: String = ""
    private var currentDescription: String = ""
    private var currentRoom: String = ""
    private var currentStart: String = ""
    private var currentDuration: String = ""
    
    private var parserCompletionHandler: (([XmlTags]) -> Void)?
    
    init(data: Data) {
        super.init()
        let parser = XMLParser(data: data)
        parser.delegate = self
        parser.parse()
    }
    
    func getXml() -> [XmlTags] {
        return self.xmlItems
    }
    
    
    func parseFeed(url: String, completionHandler: @escaping (([XmlTags]) -> Void)) {
        self.parserCompletionHandler = completionHandler
        let request = URLRequest(url: URL(string: url)!)
        let urlSession = URLSession.shared
        let task = urlSession.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                if let error = error {
                    print(error.localizedDescription)
                }
                return
            }
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
        }
        task.resume()
    }
    
    //MARK: xml parser delegate
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        currentElement = elementName
        
        
        if currentElement == "event" {
            currentPerson = ""
            currentTitle = ""
            currentDescription = ""
            currentRoom = ""
            currentStart = ""
            currentDuration = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        switch currentElement {
        case "start":
            currentStart += string
        case "duration":
            //print(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentDuration += string
        case "room":
            //print(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentRoom += string
        case "description":
            //print(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentDescription += string
        case "title":
            //print(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentTitle += string
        case "person":
            //print(string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))
            currentPerson += string
        default:
            break
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        //TODO
        if elementName == "event" {
            let xmlItem = XmlTags(title: currentTitle, persons: currentPerson, description: currentDescription, room: currentRoom, start: currentStart, duration: currentDuration)
            self.xmlItems.append(xmlItem)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        parserCompletionHandler?(xmlItems)
    }
    
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print(parseError.localizedDescription)
    }
}
