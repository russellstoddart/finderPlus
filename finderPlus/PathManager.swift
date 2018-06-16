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
    var currentURL: URL
    
    let fileManager: FileManager
    
    init(startPath: String = NSHomeDirectory(), fileManager: FileManager = FileManager()) {
        
        currentPath = startPath
        currentURL = fileManager.homeDirectoryForCurrentUser
        
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
        
        contentsOfCurrentURL()

        fileManager.changeCurrentDirectoryPath(currentPath)
        
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
    
    private func contentsOfCurrentURL() {

        do {
            let urlsForCurrentURL = try fileManager.contentsOfDirectory(at: currentURL, includingPropertiesForKeys: [URLResourceKey(rawValue: "NSURLNameKey")], options: [.skipsSubdirectoryDescendants, .skipsHiddenFiles])
            let namesForCurrentURL = urlsForCurrentURL.first!.path
            print(urlsForCurrentURL.count, namesForCurrentURL, "\n", urlsForCurrentURL.first!, "\n", fileManager.currentDirectoryPath)
            fileManager.changeCurrentDirectoryPath(NSHomeDirectory())
        } catch {

        }

//        for url in contents {
//            
//            if let url = url as? URL {
//                
//                print(url)
//            }
//        }
    }
}
