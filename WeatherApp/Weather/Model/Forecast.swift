//
//  Forecast.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation

struct Forecast: Codable {
    let time: String
    let temperature: String
    let description: String
}
