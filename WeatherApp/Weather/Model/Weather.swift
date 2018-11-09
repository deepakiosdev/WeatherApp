//
//  Weather.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation

struct Weather {

    let cityName: String
    let country: String
    let weaterDetails : [WeatherDetail]
    
    private enum CodingKeys: String, CodingKey {
        case city
        case weaterDetails = "list"
    }
    
    enum CityKeys: String, CodingKey {
        case cityName = "name"
        case country
    }
}


extension Weather: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(weaterDetails, forKey: .weaterDetails)
        
        var cityContainer = container.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        try cityContainer.encode(cityName, forKey: .cityName)
        try cityContainer.encode(country, forKey: .country)
    }
}


extension Weather: Decodable {
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weaterDetails = try values.decodeIfPresent([WeatherDetail].self, forKey: .weaterDetails) ?? []
        
        let cityValues = try values.nestedContainer(keyedBy: CityKeys.self, forKey: .city)
        cityName = try cityValues.decodeIfPresent(String.self, forKey: .cityName) ?? ""
        country = try cityValues.decodeIfPresent(String.self, forKey: .country) ?? ""
    }
    
}


struct WeatherDetail {
    
    let dateTime: String
    var description = ""
    let currentTemperature: Float
    let maxTemperature: Float
    let minTemperature: Float
    let humidity: Float
    let windSpeed: Float

    
    private enum CodingKeys: String, CodingKey {
        case dateTime = "dt_txt"
        case main
        case weather
        case wind
    }
    
    enum MainKeys: String, CodingKey {
        case currentTemperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case humidity
    }
    
    enum WeatherKeys: String, CodingKey {
        case description
    }
    
    enum WindKeys: String, CodingKey {
        case windSpeed = "speed"
    }
    
}


extension WeatherDetail: Encodable {
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dateTime, forKey: .dateTime)

        var mainContainer = container.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        try mainContainer.encode(currentTemperature, forKey: .currentTemperature)
        try mainContainer.encode(minTemperature, forKey: .minTemperature)
        try mainContainer.encode(maxTemperature, forKey: .maxTemperature)
        try mainContainer.encode(humidity, forKey: .humidity)
        
        var weatherContainer = container.nestedContainer(keyedBy: WeatherKeys.self, forKey: .weather)
        try weatherContainer.encode(description, forKey: .description)
        
        var windContainer = container.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        try windContainer.encode(windSpeed, forKey: .windSpeed)
        
    }
    
}


extension WeatherDetail: Decodable {
    
    init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dateTime = try values.decodeIfPresent(String.self, forKey: .dateTime) ?? ""

        let mainValues = try values.nestedContainer(keyedBy: MainKeys.self, forKey: .main)
        currentTemperature = try mainValues.decodeIfPresent(Float.self, forKey: .currentTemperature) ?? 0.0
        minTemperature = try mainValues.decodeIfPresent(Float.self, forKey: .minTemperature) ?? 0.0
        maxTemperature = try mainValues.decodeIfPresent(Float.self, forKey: .maxTemperature) ?? 0.0
        humidity = try mainValues.decodeIfPresent(Float.self, forKey: .humidity) ?? 0.0
     
        var weatherValues = try values.nestedUnkeyedContainer(forKey:.weather)

        while (!weatherValues.isAtEnd) {
            let weatherInfo = try weatherValues.nestedContainer(keyedBy: WeatherKeys.self)
            description = try weatherInfo.decodeIfPresent(String.self, forKey: .description) ?? ""
        }
        
        let windValues = try values.nestedContainer(keyedBy: WindKeys.self, forKey: .wind)
        windSpeed = try windValues.decodeIfPresent(Float.self, forKey: .windSpeed) ?? 0.0
    }
    
    
}
