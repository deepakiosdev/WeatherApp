//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherViewModel {
    
    // MARK: - Constants
   private let emptyString = ""
    
    // MARK: - Properties
    let isFetchingData: Observable<Bool>
    let hasError: Observable<Bool>
    let processMessage: Observable<String>
    let location: Observable<String>
    let temperature: Observable<String>
    let weatherDescription: Observable<String>
    let maxTemp: Observable<String>
    let minTemp: Observable<String>
    let humdity: Observable<String>
    let windSpeed: Observable<String>
    let forecasts: Observable<[ForecastCellViewModel]>
    
    // MARK: - Dependency Injection
    fileprivate var locationService: LocationService

    // MARK: - init
    init() {
        isFetchingData = Observable(false)
        hasError = Observable(true)
        processMessage = Observable("")
        
        location = Observable(emptyString)
        temperature = Observable(emptyString)
        weatherDescription = Observable(emptyString)
        maxTemp = Observable(emptyString)
        minTemp = Observable(emptyString)
        humdity = Observable(emptyString)
        windSpeed = Observable(emptyString)

        forecasts = Observable([])
        
        // Put Dependency Injection here
        locationService = LocationService()
    }
    
    // MARK: - public
    func startLocationService() {
        processMessage.value = "Fetching weather details..."
        isFetchingData.value = true
        locationService.delegate = self
        locationService.requestLocation()
    }
    
    // MARK: - private
    private func update(_ weather: Weather) {
        processMessage.value = ""
        location.value = weather.cityName + ", \(weather.country)"

        guard let currentWeather = weather.weaterDetails.first else {
            update(WAError.noData)
            return
        }
        
        temperature.value = "\(currentWeather.currentTemperature) °C"
        weatherDescription.value = currentWeather.description.capitalized
        maxTemp.value = "\(currentWeather.maxTemperature) °C"
        minTemp.value = "\(currentWeather.minTemperature) °C"
        humdity.value = "\(currentWeather.humidity) %"
        windSpeed.value = "\(currentWeather.windSpeed) meter/sec"

        //Construct Froecast data model array. Drop first WeatherDetail object from forecast model array because it represnts current time weather condition
        constructForecastDataModel(fromWeatherDetails: Array(weather.weaterDetails.dropFirst()))
        hasError.value = false
        isFetchingData.value = false
    }
    
    
    private func update(_ error: WAError) {
        hasError.value = true
        switch error {
        case .invalidURL, .requestParameterError:
            processMessage.value = "The weather service is not working."
        case .networkRequestFailed, .noData:
            processMessage.value = "The network appears to be down."
        case .jsonParsingFailed:
            processMessage.value = "We're having trouble parsing weather data."
        case .unableToFindLocation:
            processMessage.value = "We're having trouble getting user location."
        case .unknown(let errorMsg):
            processMessage.value = errorMsg
        }
        
        location.value = emptyString
        temperature.value = emptyString
        weatherDescription.value = emptyString
        maxTemp.value = emptyString
        minTemp.value = emptyString
        humdity.value = emptyString
        windSpeed.value = emptyString
        
        self.forecasts.value = []
        isFetchingData.value = false
        hasError.value = true
    }
    
    private func constructForecastDataModel(fromWeatherDetails weatherDetails: [WeatherDetail]) {
        
        if (weatherDetails.count > 0) {
            let tempForecasts = weatherDetails.map { forecast in
                return ForecastCellViewModel(forecast)
            }
            forecasts.value = tempForecasts
            
        } else {
            self.forecasts.value = []
        }
    }
}


// MARK: LocationServiceDelegate
extension WeatherViewModel: LocationServiceDelegate {
    
    func locationDidUpdate(_ service: LocationService, location: CLLocation) {
        var weatherService = OpenWeatherMapService()

        weatherService.retrieveWeatherInfo(location) { (weather, error) -> Void in
            DispatchQueue.main.async(execute: {
                if let unwrappedError = error {
                    print(unwrappedError)
                    self.update(unwrappedError)
                    return
                }
                
                guard let unwrappedWeather = weather else {
                    return
                }
                self.update(unwrappedWeather)
            })
        }
    }
    
    
    func locationDidFail(withError error: WAError) {
        self.update(error)
    }
}
