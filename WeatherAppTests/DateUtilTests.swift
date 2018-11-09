//
//  DateUtilTests.swift
//  WeatherAppTests
//
//  Created by Dipak Pandey on 05/11/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import XCTest
@testable import WeatherApp

class DateUtilTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
        super.tearDown()
    }
    

    func testForcastDateTimeString() {
        let dateTimeSting = DateUtility(date: "2018-11-08 15:00:00")
        let formatedDateString = dateTimeSting.forcastDateTimeString
        XCTAssertEqual(formatedDateString, "Nov 8, 2018\n\n03:00 PM", "Date utility returns wrong result")
    }
    
    func testForcastDateTimeStringWithBlankDate() {
        let dateTimeSting = DateUtility(date: "").forcastDateTimeString
        XCTAssertEqual(dateTimeSting, "\n\n", "Blank date result in wrong")
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
