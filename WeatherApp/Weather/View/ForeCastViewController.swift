//
//  ForeCastViewController.swift
//  WeatherApp
//
//  Created by Dipak Pandey on 28/10/18.
//  Copyright © 2018 Dipak Pandey. All rights reserved.
//

import UIKit

class ForeCastViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var foreCastData: [ForecastCellViewModel] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

// MARK: - UICollectionViewDataSource
extension ForeCastViewController {

    func collectionView(_ collectionView: UICollectionView,
                                 numberOfItemsInSection section: Int) -> Int {
        return foreCastData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "forecastCell",
                                                      for: indexPath) as! ForecastCell
        
        cell.configure(viewModel: foreCastData[indexPath.row])
        
        return cell
    }
}
