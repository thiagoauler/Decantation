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

let decanter = Decanter(databasePath: datFilePath)
decanter.process(selectedRegions: ["Brazil", "World", "USA", "Europe"])

print("Ignored:")
for game in decanter.ignoredGames.sorted(by: { return $0.name < $1.name })
{
    print(game.name)
    if game.isProper()
    {
        if let cloneof = game.cloneof
        {
            print(" >", cloneof)
        }
        else
        {
            print(" > [null]")
        }
    }
}

print("\nDatabase:")
for game in decanter.validGames.values.sorted(by: { return $0.name < $1.name })
{
    print(game.name, "-", game.rom.crc)
}
