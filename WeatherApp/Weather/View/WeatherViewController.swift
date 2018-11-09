//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {

    @IBOutlet weak var refreshWeatherBtn: UIButton!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var locationLbl: UILabel!
    @IBOutlet weak var currentTemperatureLbl: UILabel!
    @IBOutlet weak var weatherDescriptionLbl: UILabel!
    @IBOutlet weak var maxTemperatureLbl: UILabel!
    @IBOutlet weak var minTemperatureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
  
    var foreCastVC: ForeCastViewController?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = WeatherViewModel()
        viewModel?.startLocationService()

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let vc = segue.destination as? ForeCastViewController,
            segue.identifier == "ForeCastViewController" {
            self.foreCastVC = vc
        }
    }
    
    
    @IBAction func refreshWeatherButtonPressed(_ sender: UIButton) {
        viewModel?.startLocationService()
    }
    
    // MARK: - ViewModel
    var viewModel: WeatherViewModel? {
        
        didSet {
            viewModel?.location.observe {
                [unowned self] in
                self.locationLbl.text = $0
            }
            
            viewModel?.temperature.observe {
                [unowned self] in
                self.currentTemperatureLbl.text = $0
            }
            
            viewModel?.weatherDescription.observe {
                [unowned self] in
                self.weatherDescriptionLbl.text = $0
            }
            
            viewModel?.maxTemp.observe {
                [unowned self] in
                self.maxTemperatureLbl.text = $0
            }
            
            viewModel?.minTemp.observe {
                [unowned self] in
                self.minTemperatureLbl.text = $0
            }
            
            viewModel?.humdity.observe {
                [unowned self] in
                self.humidityLbl.text = $0
            }
            
            viewModel?.windSpeed.observe {
                [unowned self] in
                self.windSpeedLbl.text = $0
            }
            
            viewModel?.forecasts.observe {
                [unowned self] (forecasts) in
                 self.foreCastVC?.foreCastData = forecasts
                
            }
            
            viewModel?.processMessage.observe {
                [unowned self]  in
                self.messageLbl.text = $0
                
            }
            
            viewModel?.isFetchingData.observe {
                [unowned self]  in
                let isLoading = $0
                self.loadingView.isHidden = !isLoading
                self.refreshWeatherBtn.isUserInteractionEnabled = !isLoading
                self.loadingIndicator.isHidden = !isLoading

            }
            
            viewModel?.hasError.observe {
                [unowned self]  in
                let hasError = $0
                
                self.loadingView.isHidden = !hasError
            }
        }
    }
    
}

