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

print("Hello, World!")
