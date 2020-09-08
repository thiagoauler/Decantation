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
    var gameName: String = ""
    
    // [gameName : Game]
    var dataBase: [String: Game] = [String: Game]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        switch elementName
        {
        case "game":
            let game = Game()
            game.name = attributeDict["name"]!
            game.cloneof = attributeDict["cloneof"]
            
            gameName = game.name
            dataBase[gameName] = game
        case "release":
            if let game = dataBase[gameName]
            {
                let release = Release()
                release.name = attributeDict["name"]!
                release.region = attributeDict["region"]!
                
                game.releases.append(release)
            }
        case "rom":
            if let game = dataBase[gameName]
            {
                let rom = Rom()
                rom.name = attributeDict["name"]!
                rom.size = attributeDict["size"]!
                rom.crc = attributeDict["crc"]!
                rom.md5 = attributeDict["md5"]!
                rom.sha1 = attributeDict["sha1"]!
                
                game.rom = rom
            }
        default:
            break
        }
    }
    
    class func perform(datFilePath path: String) -> [String: Game]
    {
        let url = NSURL(fileURLWithPath: path) as URL
        let parser = Parser()
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = parser
        xmlParser.parse()
        
        return parser.dataBase
    }
}
