//
//  CommandTests.swift
//  finderPlusTests
//
//  Created by Russell Stoddart on 15/06/2018.
//  Copyright © 2018 Russell Stoddart. All rights reserved.
//

import XCTest
@testable import finderPlus

class CommandTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testListOfArgumentsReturnsAnArrayOfArgumentsSeperatedBySpaces() {
        let listAllCommand = Command(phrase: "ls -la")

        let expectedListAllArgumentList = ["ls", "-la"]
        let resultListAllArgumentList = listAllCommand.listOfArguments()

        XCTAssertEqual(expectedListAllArgumentList, resultListAllArgumentList)

        let podInstallCommand = Command(phrase: "pod install --no-repo-update")

        let expectedPodInstallArgumentList = ["pod", "install", "--no-repo-update"]
        let resultPostInstallArgumentList = podInstallCommand.listOfArguments()

        XCTAssertEqual(expectedPodInstallArgumentList, resultPostInstallArgumentList)
    }

    func testListOfArgumentsReturnsAnArrayOfArgumentsSeperatedBySpaces_KeepingArgumentsWithinDoubleQuotesAsOne() {
        let command = Command(phrase: "\"finderPlus.xcworkspace\"")

        let expectedArgumentList = ["finderPlus.xcworkspace"]
        let resultArgumentList = command.listOfArguments()

        XCTAssertEqual(expectedArgumentList, resultArgumentList)

        let xcodebuildCommand = Command(phrase: "-destination \"platform=iOS Simulator,OS=11.3,name=iPhone 6s\" -workspace \"finderPlus.xcworkspace\"")

        let expectedListAllArgumentList = ["-destination", "platform=iOS Simulator,OS=11.3,name=iPhone 6s", "-workspace", "finderPlus.xcworkspace"]
        let resultListAllArgumentList = xcodebuildCommand.listOfArguments()

        XCTAssertEqual(expectedListAllArgumentList, resultListAllArgumentList)
    }
}
