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
    exit(1)
}

let fm = FileManager.default
let datFilePath = CommandLine.arguments[1]

if !fm.fileExists(atPath: datFilePath)
{
    print("Database does not exist.")
    exit(1)
}

let decanter = Decanter(databasePath: datFilePath)
decanter.process(selectedRegions: ["Brazil", "World", "USA", "Europe"])

print(" --- Decanter ---")
print()
print("Processing \"\(decanter.databaseName)\" database.")

let romFolder = fm.currentDirectoryPath + "/" + decanter.databaseName + "/"
if (!fm.fileExists(atPath: romFolder))
{
    print("Rom directory does not exist.")
    exit(1)
}

let ignoredPath = romFolder + "_ignored.txt"
print()
print("Ignored entries in:", ignoredPath)
var ignoredRoms = ""
for game in decanter.ignoredGames.sorted(by: { return $0.name < $1.name })
{
    if game.isProper()
    {
        if let cloneof = game.cloneof
        {
            ignoredRoms += game.name + " > " + cloneof + "\n"
        }
        else
        {
            ignoredRoms += game.name + " > [null]" + "\n"
        }
    }
    else
    {
        ignoredRoms += "**" + game.name + "\n"
    }
}
fm.createFile(atPath: ignoredPath, contents: ignoredRoms.data(using: String.Encoding.ascii))

print()
print("Processing directory:", romFolder)

for romFilePath in try fm.contentsOfDirectory(atPath: romFolder)
{
    if !romFilePath.starts(with: ".") && !romFilePath.starts(with: "_")
    {
        print(romFilePath)
    }
}

/*print()
(print("\nDatabase:")
for game in decanter.validGames.values.sorted(by: { return $0.name < $1.name })
{
    print(game.rom.name, "-", game.rom.crc)
}*/
