//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherServiceProtocol
{
    typealias WeatherCompletionHandler = (Weather?, WAError?) -> Void
    mutating func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler)
}
