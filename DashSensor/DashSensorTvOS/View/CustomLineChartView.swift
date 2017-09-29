//
//  CustomLineChartView.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/22/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import Charts

class CustomLineChartView: LineChartView {
    var isHourFormat = false
    
    private var chartData = LineChartData()
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        // No data setup
        self.noDataTextColor = UIColor.black
        self.noDataText = "No data for the chart"
        self.backgroundColor = UIColor.white
        
    }
    
    func setData(dataArray: [Int], timestampArray: [Int], field: String) {
        var lineDataEntry: [ChartDataEntry] = []
        
        if (dataArray.count == 0) {
            self.data = nil
            self.layoutIfNeeded()
            return
        }
        
        // Data Point setup & color config
        for i in 0..<dataArray.count {
            let dataPoint = ChartDataEntry(x: Double(timestampArray[i]), y: Double(dataArray[i]))
            lineDataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: field)
        chartDataSet.drawCirclesEnabled = false
        chartDataSet.mode = .horizontalBezier
        
        chartData = LineChartData()
        chartData.setDrawValues(true)
        chartData.addDataSet(chartDataSet)
        
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
        
        startAnimation()
        
    }
    
    func startAnimation() {
        if chartData.dataSets.count == 0 {
            return
        }
        self.animate(yAxisDuration: 1.0, easingOption: .easeInOutCirc)
        self.data = chartData
        self.layoutIfNeeded()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
