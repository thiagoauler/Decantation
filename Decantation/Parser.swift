//
//  Parser.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 02/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

class Parser : NSObject, XMLParserDelegate
{
    var databaseName = ""
    var currentGame = Game()
    var dataBase = [Game]()
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        switch elementName
        {
        case "name":
            databaseName = "header/name"
        case "game":
            currentGame = Game()
            currentGame.name = attributeDict["name"]!
            currentGame.cloneof = attributeDict["cloneof"]
            
            dataBase.append(currentGame)
        case "release":
            let release = Game.Release()
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
    
    func parser(_ parser: XMLParser, foundCharacters string: String)
    {
        if databaseName == "header/name"
        {
            databaseName = string
            if let index = databaseName.firstIndex(of: "(")
            {
                databaseName = String(databaseName[..<index])
            }
            databaseName = databaseName.trimmingCharacters(in: [" "])
        }
    }
}
