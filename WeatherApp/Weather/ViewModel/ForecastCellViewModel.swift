//
//  ForecastCellViewModel.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 02/11/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation


struct ForecastCellViewModel {
    
    let dateTime: Observable<String>
    let temperature: Observable<String>
    let description: Observable<String>
    
    init(_ weatherDetail: WeatherDetail) {
        //Get formated date string from soruce date string
        let dateTimeSting = DateUtility(date: weatherDetail.dateTime).forcastDateTimeString
        dateTime = Observable(dateTimeSting)
        
        temperature = Observable("\(weatherDetail.currentTemperature) °C")
        description = Observable(weatherDetail.description.capitalized)
    }
}



