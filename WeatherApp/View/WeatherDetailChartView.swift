//
//  WeatherDetailChartView.swift
//  WeatherApp
//
//  Created by zhu on 2025/1/19.
//

import Foundation
import UIKit
import Charts


class ChartAxisValueFormatter: NSObject, IAxisValueFormatter{
    
    var hourDetailVOs:[WeatherHourDetailVO]?
    
    init(vos:[WeatherHourDetailVO]?) {
        hourDetailVOs = vos
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        guard let hourDetailVOs = hourDetailVOs else {
            return "\(value)"
        }
        
        let index = Int(value)
        return   hourDetailVOs.count > index && index >= 0 ? hourDetailVOs[index].timeStr! : ""
    }
    
}

class WeatherDetailChartView: UIView, ChartViewDelegate {
    
    @IBOutlet weak var lineChartView: LineChartView!

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.cornerRadius = 10
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    func updateView(vo: WeatherDayDetailVO?) {
        guard let detailVOS = vo?.detailVOs else {
            return
        }
        
        lineChartView?.dragEnabled = true
        lineChartView.legend.form = .none
        lineChartView.doubleTapToZoomEnabled = false
        lineChartView.delegate = self
        
        let xAxis = lineChartView.xAxis
        xAxis.axisLineWidth = 1/UIScreen.main.scale
        xAxis.labelPosition = .bottom
        xAxis.labelFont = UIFont.systemFont(ofSize: 12)
        xAxis.labelTextColor = UIColor.black
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = ChartAxisValueFormatter(vos: detailVOS) as IAxisValueFormatter

        lineChartView.rightAxis.enabled = false
        lineChartView.leftAxis.drawGridLinesEnabled = false
        
        var dataEntrys = [ChartDataEntry]()
        for (index, detailVO) in detailVOS.enumerated() {
            let dateEntry = ChartDataEntry(x: Double(index), y: Double(detailVO.temperature ?? 0), data: detailVO.timeStr)
            dataEntrys.append(dateEntry)
        }
        
        let dataSet = LineChartDataSet(entries: dataEntrys, label: nil)
        dataSet.lineWidth = 2
        dataSet.colors = [UIColor(red: 248/255.0, green: 110/255.0, blue: 80/255.0, alpha: 1)]
        dataSet.drawCircleHoleEnabled = false
        dataSet.circleRadius = 3
        dataSet.circleColors = [UIColor(red: 0, green: 162/255.0, blue: 1, alpha: 1)]
        let chartData = LineChartData(dataSet: dataSet)
        lineChartView.zoom(scaleX: 2, scaleY: 1, x: 0, y: 0)
        lineChartView.data = chartData
    }
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        showMarkerView(entry: entry)
    }
    
    func showMarkerView(entry:ChartDataEntry)
    {
        let marker = MarkerView.init(frame: CGRect(x: 20, y: 20, width: 100, height: 20))
        marker.chartView = self.lineChartView
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        label.text = "\(entry.data as? String ?? "")  \(String(format: "%.1f", entry.y))°C"
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.backgroundColor = UIColor(red: 0, green: 162/255.0, blue: 1, alpha: 1)
        label.textAlignment = .center
        marker.addSubview(label)
        self.lineChartView.marker = marker
    }
    
}
