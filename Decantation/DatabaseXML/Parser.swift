//
//  DatParser.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 02/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

class Parser : NSObject, XMLParserDelegate
{
    var currentGame = Game()
    var dataBase = [Game]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        switch elementName
        {
        case "game":
            currentGame = Game()
            currentGame.name = attributeDict["name"]!
            currentGame.cloneof = attributeDict["cloneof"]
            
            dataBase.append(currentGame)
        case "release":
            let release = Release()
            release.name = attributeDict["name"]!
            release.region = attributeDict["region"]!
            
            currentGame.releases.append(release)
        case "rom":
            currentGame.rom.name = attributeDict["name"]!
            currentGame.rom.size = attributeDict["size"]!
            currentGame.rom.crc = attributeDict["crc"]!
            currentGame.rom.md5 = attributeDict["md5"]!
            currentGame.rom.sha1 = attributeDict["sha1"]!
        default:
            break
        }
    }
    
    class func createDatabase(databasePath path: String) -> [Game]
    {
        let parser = Parser()
        
        let url = NSURL(fileURLWithPath: path) as URL
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = parser
        xmlParser.parse()
        
        return parser.dataBase
    }
}
