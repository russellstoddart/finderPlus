//
//  Command.swift
//  finderPlus
//
//  Created by Russell Stoddart on 15/06/2018.
//  Copyright © 2018 Russell Stoddart. All rights reserved.
//

import Cocoa

class Command {
    private let phrase: String

    init(phrase: String) {
        self.phrase = phrase
    }

    fileprivate func extractedFunc(_ phrase: String) -> [String] {
        var mutablePhrase = phrase
        var arguments: [String] = []
        var isQuotedArgument = false
        for (index, character) in phrase.enumerated() {
            let characterAsString = String(character)
            if index == phrase.count - 1 {
                arguments.append(mutablePhrase)
            } else if characterAsString.contains("\"") {
                isQuotedArgument = !isQuotedArgument
            } else if character == " " && !isQuotedArgument {
                arguments.append(phrase.substring(to: phrase.index(phrase.startIndex, offsetBy: index)))
                mutablePhrase.removeSubrange(phrase.index(phrase.startIndex, offsetBy: 0)..<phrase.index(phrase.startIndex, offsetBy: index + 1))
                arguments.append(contentsOf: extractedFunc(mutablePhrase))
                break
            }
        }
        return arguments
    }

    func listOfArguments() -> [String] {
        let args = extractedFunc(phrase)
        let cleanedArgs = args.map { $0.replacingOccurrences(of: "\"", with: "") }
        return cleanedArgs
    }
}
