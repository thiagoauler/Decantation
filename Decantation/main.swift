//
//  main.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 02/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

func isEligible(database: [String: Game], game: Game, regions: [String]) -> Bool
{
    if game.isUnreleased()
    {
        game.name = "[UNOFFICIAL] " + game.name
        return false
    }
    
    if game.isDigital()
    {
        game.name = "[DIGITAL] " + game.name
        return false
    }
    
    if game.isCollection()
    {
        game.name = "[PACK] " + game.name
        return false
    }
    
    if game.isBios()
    {
        return false
    }
    
    let currentGamePriority = game.getRegionPriority(from: regions)
    
    if let existingGame = database[game.key]
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
    
    return false
}


if CommandLine.argc == 1
{
    print("Database required.")
}

let datFilePath = CommandLine.arguments[1]

if !FileManager.default.fileExists(atPath: datFilePath)
{
    print("Database does not exist.")
}

let database = Parser.perform(datFilePath: datFilePath)

var ignoredGames = [Game]()
var validGames = [String: Game]()

for currentGame in database.values
{
    if isEligible(database: validGames, game: currentGame, regions: ["Brazil", "World", "USA", "Europe"])
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

print("Ignored:")
for game in ignoredGames.sorted(by: { return $0.name < $1.name })
{
    print(game.name)
    if let cloneof = game.cloneof
    {
        print(" -", cloneof)
    }
}

/*print("\nDatabase:")
for game in validGames.values.sorted(by: { return $0.name < $1.name })
{
    print(game.name)
}*/

extension String
{
    static func ~= (lhs: String, rhs: String) -> Bool
    {
        guard let regex = try? NSRegularExpression(pattern: rhs) else { return false }
        let range = NSRange(location: 0, length: lhs.utf16.count)
        return regex.firstMatch(in: lhs, options: [], range: range) != nil
    }
}
