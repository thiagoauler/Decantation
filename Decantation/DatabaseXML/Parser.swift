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
            let rom = Rom()
            rom.name = attributeDict["name"]!
            rom.size = attributeDict["size"]!
            rom.crc = attributeDict["crc"]!
            rom.md5 = attributeDict["md5"]!
            rom.sha1 = attributeDict["sha1"]!
                
            currentGame.rom = rom
        default:
            break
        }
    }
    
    class func createDatabase(datFilePath path: String) -> [Game]
    {
        let url = NSURL(fileURLWithPath: path) as URL
        let parser = Parser()
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = parser
        xmlParser.parse()
        
        return parser.dataBase
    }
}
