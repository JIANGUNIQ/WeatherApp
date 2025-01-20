//
//  WeatherHourDetailCell.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import UIKit

class WeatherHourDetailCell: UICollectionViewCell{
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private(set) var detailVO: WeatherHourDetailVO?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 15
    }
    
    func updateView(vo: WeatherHourDetailVO?) {
        detailVO = vo

        timeLabel.text = detailVO?.timeStr
        temperatureLabel.text = detailVO?.temperatureStr
    }
    
}
