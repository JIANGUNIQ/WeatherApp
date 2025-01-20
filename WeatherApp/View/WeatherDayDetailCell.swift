//
//  WeatherDayDetailCell.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import UIKit

class WeatherDayDetailCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {
   
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!

    private(set) var detailVO: WeatherDayDetailVO?

  
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.contentView.layer.cornerRadius = 10
        
    }
    
    
    func updateView(vo: WeatherDayDetailVO) {
        detailVO = vo
        timeLabel.text = detailVO?.timeStr
       
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).itemSize = CGSize(width: 50, height: 80)
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumLineSpacing = 10
        (collectionView.collectionViewLayout as! UICollectionViewFlowLayout).minimumInteritemSpacing = 20
        collectionView.reloadData()
    }
    
    // MARK: - UICollectionViewDelegate UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailVO?.detailVOs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let detailCell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherHourDetailCell", for: indexPath) as! WeatherHourDetailCell
        detailCell.updateView(vo: detailVO?.detailVOs![indexPath.row])
        
        return detailCell
    }
    
}
