//
//  OpenWeatherMapWebService.swift
//  WeatherAppTests
//
//  Created by Dipak Pandey on 08/11/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import XCTest
import CoreLocation

@testable import WeatherApp

class OpenWeatherMapWebService: XCTestCase {
    
    var location: CLLocation!
    var weatherService: OpenWeatherMapService!


    override func setUp() {
        super.setUp()
        location = CLLocation.init(latitude: 12.950064363906026, longitude: 77.71620062669801) // Coordinates of Bangalore
        //location = CLLocation.init(latitude: 00.232323, longitude: -02.23232) // Wrong input
        weatherService = OpenWeatherMapService()

    }

    override func tearDown() {
        location = nil
        weatherService = nil
        
        super.tearDown()
    }

    func testOpenWeatherMapWebServiceApiSuccessCase() {
        
        //given
        let promise = expectation(description: "Completion handler invoked")
        var errorStatus: WAError?
        
        //when
        weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
            
            promise.fulfill()
            errorStatus = error
           // print("Test City:\(String(describing: weather?.cityName))")
        }
        
        // 3
        waitForExpectations(timeout: 5, handler: nil)
        
        // then
        XCTAssertNil(errorStatus, errorStatus?.errorDescription ?? "Not able to fetch weather details from web service")
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
