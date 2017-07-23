//
//  PathManager.swift
//  finderPlus
//
//  Created by Russell Stoddart on 18/07/2017.
//  Copyright © 2017 Russell Stoddart. All rights reserved.
//

import Foundation

class PathManager {
    
    var currentPath: String
    
    let fileManager: FileManager
    
    init(startPath: String = NSHomeDirectory(), fileManager: FileManager = FileManager()) {
        
        currentPath = startPath
        
        self.fileManager = fileManager
    }
    
    func contentsOfStartPath() -> [String] {
        
        return contentsOfCurrentPath()
    }
    
    func contentsOfChildDirectory(named directory: String) -> [String] {
        
        currentPath = currentPath.appending("/\(directory)")
        
        return contentsOfCurrentPath()
    }
    
    func contentsOfParentDirectory() -> [String] {
        
        let pathComponents = currentPath.components(separatedBy: "/")
        let choppedPathComponents = pathComponents.filter({ (string) -> Bool in
            
            if pathComponents.last == string {
                
                return false
            }
            
            return true
        })
        let choppedPath = choppedPathComponents.joined(separator: "/")
        
        currentPath = choppedPath
        
        return contentsOfCurrentPath()
    }
    
    private func contentsOfCurrentPath() -> [String] {
        
        var contents: [String] = []
        
        do {
            
            let oldContents = try fileManager.contentsOfDirectory(atPath: currentPath)
            contents = oldContents.filter({ (string) -> Bool in
                
                if string.characters.first == "." {
                    
                    return false
                }
                
                return true
            })
            
        } catch {
            
        }
        
        return contents
    }
}
