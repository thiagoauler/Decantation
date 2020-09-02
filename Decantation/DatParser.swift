//
//  DatParser.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 02/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

class DatParser : NSObject, XMLParserDelegate
{
    var crcTag: Bool = false
    var gameName: String = ""
    var dataBase: [String: String] = ["":""]
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        if (elementName == "game")
        {
            gameName = attributeDict["name"]!
        }
        
        crcTag = (elementName == "crc")
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if (crcTag)
        {
            dataBase[string] = gameName
            crcTag = false
        }
    }
    
    class func perform(datFilePath path: String) -> [String: String]
    {
        let url = NSURL(fileURLWithPath: path) as URL
        let datParser = DatParser()
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = datParser
        xmlParser.parse()
        
        return datParser.dataBase
    }
}
