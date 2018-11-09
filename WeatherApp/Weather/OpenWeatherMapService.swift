//
//  OpenWeatherMapService.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation
import CoreLocation


struct OpenWeatherMapService: WeatherServiceProtocol, RequestType {
    
    //Constants
     private let baseUrl = "http://api.openweathermap.org/data/2.5/forecast"
     private let appId = "99da154befe98b7711871bcd61102b3f"

    //Variables
    typealias ResponseType = Weather?
    var data: RequestData = RequestData(path: "")

    
    mutating func retrieveWeatherInfo(_ location: CLLocation, completionHandler: @escaping WeatherCompletionHandler) {
        
        guard let url = generateRequestURL(location) else {
            completionHandler(nil, WAError.invalidURL)
            return
        }
        
        self.data = RequestData(path:url)
        
        self.execute(onSuccess: { (weather: Weather?) in
            completionHandler(weather, nil)
        }) { (error: WAError) in
            completionHandler(nil, error)
        }
        
    }
    
    private func generateRequestURL(_ location: CLLocation) -> String? {
        guard var components = URLComponents(string:baseUrl) else {
            return nil
        }
        
        let latitude = String(location.coordinate.latitude)
        let longitude = String(location.coordinate.longitude)
        
        components.queryItems = [URLQueryItem(name:"units", value:"metric"),
                                 URLQueryItem(name:"lat", value:latitude),
                                 URLQueryItem(name:"lon", value:longitude),
                                 URLQueryItem(name:"appid", value:appId)]
        
        let urlString = components.url?.absoluteString
        print("Url String:\(String(describing: urlString))")
        return urlString
    }
}
