//
//  FocusOnUITests.swift
//  FocusOnUITests
//
//  Created by Rafal Padberg on 13.08.19.
//  Copyright © 2019 Rafal Padberg. All rights reserved.
//

import XCTest
@testable import FocusOn

class FocusOnUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDown() {
        
    }
}
