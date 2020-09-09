//
//  Game.swift
//  Decantation
//
//  Created by Thiago Auler dos Santos on 03/09/2020.
//  Copyright © 2020 Thiago Auler dos Santos. All rights reserved.
//

import Foundation

class Game
{
    var name = ""
    var cloneof: String?
    var releases = [Release]()
    var rom = Rom()
    
    var key: String
    {
        get
        {
            // the hash key will be the name of the game...
            var key = self.name
            if let cloneof = self.cloneof
            {
                //... or the parent's
                key = cloneof
            }
            return key
        }
    }
    
    func getRegionPriority(from selectedRegions: [String]) -> Int
    {
        for currentRegion in selectedRegions
        {
            if self.isFrom(region: currentRegion)
            {
                return selectedRegions.firstIndex(of: currentRegion)!
            }
        }
        return Int.max
    }
    
    func isFrom(region: String) -> Bool
    {
        return self.name ~= "\\(.*\(region).*\\)"
    }
    
    func isUnreleased() -> Bool
    {
        return self.isFrom(region: "Alt") ||
               self.isFrom(region: "Beta") ||
               self.isFrom(region: "Demo") ||
               self.isFrom(region: "Pirate") ||
               self.isFrom(region: "Program") ||
               self.isFrom(region: "Proto") ||
               self.isFrom(region: "Sample") ||
               self.isFrom(region: "Test Program") ||
               self.isFrom(region: "Unl")
    }
    
    func isDigital() -> Bool
    {
        return self.isFrom(region: "Archives") ||
               self.isFrom(region: "Collection") ||
               self.isFrom(region: "Edition") ||
               self.isFrom(region: "Pack") ||
               self.isFrom(region: "Sega Channel") ||
               self.isFrom(region: "SegaNet") ||
               self.isFrom(region: "Version") ||
               self.isFrom(region: "Virtual Console")
    }
    
    func isCollection() -> Bool
    {
        return self.name ~= "\\d* in 1" ||
               self.name ~= "\\d*-in-1" ||
               self.name ~= "\\d*-Pak" ||
               self.name ~= ".* \\+ .*" && !(self.name ~= "Sonic")
    }
    
    func isBios() -> Bool
    {
        return self.name ~= "\\[BIOS\\]"
    }
    
    func isProper() -> Bool
    {
        return !self.isBios() &&
               !self.isDigital() &&
               !self.isCollection() &&
               !self.isUnreleased()
    }
}
