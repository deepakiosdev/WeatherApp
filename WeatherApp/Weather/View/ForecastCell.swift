//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import Foundation

import UIKit

class ForecastCell: UICollectionViewCell {
    
    @IBOutlet weak var dateTimeLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var temperatureLbl: UILabel!
    
    
    // MARK: - ViewModel
    var viewModel: ForecastCellViewModel? {
        
        didSet {
            viewModel?.dateTime.observe {
                [unowned self] in
                self.dateTimeLbl.text = $0
            }
            
            viewModel?.description.observe {
                [unowned self] in
                self.descriptionLbl.text = $0
            }
            
            viewModel?.temperature.observe {
                [unowned self] in
                self.temperatureLbl.text = "\($0)"
            }
            
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(viewModel: ForecastCellViewModel) {
        self.viewModel = viewModel
    }
    
}
