//
//  Decanter.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 09/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

class Decanter
{
    var database: [Game]
    var databaseName = ""
    
    var ignoredGames = [Game]()
    var validGames = [String: Game]()
    
    init(databasePath path: String)
    {
        let parser = Parser()
        
        let url = NSURL(fileURLWithPath: path) as URL
        let xmlParser = XMLParser(contentsOf: url)!
        xmlParser.delegate = parser
        xmlParser.parse()
        
        database = parser.dataBase
        databaseName = parser.databaseName
    }
    
    func process(selectedRegions: [String])
    {
        ignoredGames.removeAll()
        validGames.removeAll()
        
        for currentGame in database
        {
            if isEligible(game: currentGame, regions: selectedRegions)
            {
                if let previousValidGame = validGames[currentGame.key]
                {
                    previousValidGame.cloneof = currentGame.name
                    ignoredGames.append(previousValidGame)
                }
                validGames[currentGame.key] = currentGame
            }
            else
            {
                if let currentValidGame = validGames[currentGame.key]
                {
                    currentGame.cloneof = currentValidGame.name
                }
                else
                {
                    currentGame.cloneof = nil
                }
                ignoredGames.append(currentGame)
            }
        }
    }
    
    func isEligible(game: Game, regions: [String]) -> Bool
    {
        if game.isProper()
        {
            let currentGamePriority = game.getRegionPriority(from: regions)
            
            if let existingGame = validGames[game.key]
            {
                //in case there is some game whith the provided key,
                //we need to match the region...
                let existingGamePriority = existingGame.getRegionPriority(from: regions)
                
                if currentGamePriority < existingGamePriority
                {
                    // the current game region has higher priority over existing game region
                    return true
                }
                
                if currentGamePriority == existingGamePriority
                {
                    // both game has equal priority...
                    //... first, we compare if the existing game is the actual parent of the release
                    if game.cloneof == existingGame.name
                    {
                        return false
                    }
                    
                    //... then, we compare the other way around
                    if existingGame.cloneof == game.name
                    {
                        return true
                    }
                    
                    //... finally, let's compare the names
                    if game.name > existingGame.name
                    {
                        return true
                    }
                }
            }
            else
            {
                //... otherwise, we insert it!
                if currentGamePriority < regions.count
                {
                    return true
                }
            }
        }
        
        return false
    }
}
