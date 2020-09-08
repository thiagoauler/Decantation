//
//  main.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 02/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

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
for game in database.values
{
    if game.name.contains("(Beta)") ||
       game.name.contains("(Proto)") ||
       game.name.contains("(Proto 1)") ||
       game.name.contains("(Proto 2)") ||
       game.name.contains("(Unl)")
    {
        ignoredGames.append(game)
    }
    else
    {
        var key = game.name
        if let cloneof = game.cloneof
        {
            key = cloneof
        }
        
        if validGames[key] == nil
        {
            validGames[key] = game
        }
        else
        {
            if game.name.contains("USA,") ||
               game.name.contains("USA)")
            {
                validGames[key] = game
                ignoredGames.append(validGames[key]!)
            }
            else
            {
                ignoredGames.append(game)
            }
        }
    }
}

print("Ignored:")
for game in ignoredGames
{
    print(game.rom.name)
}

print("\nDatabase:")
for game in validGames.values
{
    print(game.rom.name)
}
