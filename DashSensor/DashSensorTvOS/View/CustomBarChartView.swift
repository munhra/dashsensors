//
//  CustomBarChartView.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/25/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import Charts

class CustomBarChartView: BarChartView {
    var isHourFormat = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // No data setup
        self.noDataTextColor = UIColor.white
        self.noDataText = "No data for the chart"
        self.backgroundColor = UIColor.white
        
    }
    
    func setData(dataArray: [Int], timestampArray: [Int], field: String) {
        var barDataEntry: [ChartDataEntry] = []
        
        self.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInOutCirc)
        
        // Data Point setup & color config
        for i in 0..<dataArray.count {
            let dataPoint = BarChartDataEntry(x: Double(timestampArray[i]), y: Double(dataArray[i]))
            barDataEntry.append(dataPoint)
        }
        
        let chartDataSet = BarChartDataSet(values: barDataEntry, label: field)
        chartDataSet.colors = [UIColor.purple]
        
        let chartData = BarChartData()
        chartData.setDrawValues(true)
        chartData.addDataSet(chartDataSet)
        chartData.barWidth = Double(30000000.0)
        
        let formatter = ChartFormatter()
        formatter.setValue(values: timestampArray)
        
        if (isHourFormat) {
            formatter.dateFormatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
        
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawGridLinesEnabled = false
        self.xAxis.valueFormatter = xaxis.valueFormatter
        self.leftAxis.drawGridLinesEnabled = false
        self.leftAxis.drawLabelsEnabled = true
        
        self.data = chartData
        
    }
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}

