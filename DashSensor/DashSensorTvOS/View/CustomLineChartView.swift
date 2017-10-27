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
    public var themeColor = UIColor.clear
    let lightGray = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 1.0)
    
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
        self.chartDescription?.enabled = false
    }
    
    func setData(dataArray: [Int], timestampArray: [Int], field: String, timeInterval: Int) {
        var lineDataEntry: [ChartDataEntry] = []
        let nowEpochMilliseconds = Date().timeIntervalSince1970 * 1000
        
        if (dataArray.count == 0) {
            self.data = nil
            return
        }
        
        // Data Point setup & color config
        for i in 0..<dataArray.count {
            let dataPoint = ChartDataEntry(x: Double(timestampArray[i]), y: Double(dataArray[i]))
            lineDataEntry.append(dataPoint)
        }
        
        let chartDataSet = LineChartDataSet(values: lineDataEntry, label: field)
        chartDataSet.drawCirclesEnabled = true
        chartDataSet.mode = .horizontalBezier
        chartDataSet.colors = [self.themeColor]
        chartDataSet.circleColors = [self.themeColor]
        chartDataSet.circleRadius = 5.0
        chartDataSet.circleHoleRadius = 4.0
        chartDataSet.valueFont = UIFont(name: "Helvetica", size: 18)!
        
        let gradientColors = [themeColor.cgColor, UIColor.clear.cgColor] as CFArray
        let colorLocations : [CGFloat] = [1.0, 0.0]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: gradientColors, locations: colorLocations) else {
            print("gradient error")
            return
        }
        chartDataSet.fill = Fill.fillWithLinearGradient(gradient, angle: 90.0)
        chartDataSet.drawFilledEnabled = true
        
        chartData = LineChartData()
        chartData.setDrawValues(true)
        chartData.addDataSet(chartDataSet)
        
        let formatter = ChartFormatter()
        formatter.setValue(values: timestampArray)
        
        if (isHourFormat) {
            formatter.dateFormatter.dateFormat = "HH:mm"
        } else {
            formatter.dateFormatter.dateFormat = "dd/MM"
        }
        
        let xaxis: XAxis = XAxis()
        xaxis.valueFormatter = formatter
    
        self.xAxis.labelPosition = .bottom
        self.xAxis.drawGridLinesEnabled = true
        self.xAxis.valueFormatter = xaxis.valueFormatter
        self.xAxis.gridColor = UIColor(red: 206/255, green: 206/255, blue: 206/255, alpha: 0.5)
        self.xAxis.labelTextColor = lightGray
        self.xAxis.labelFont = UIFont(name: "Helvetica", size: 18)!
        self.xAxis.labelCount = 10
//        self.xAxis.axisMaximum = nowEpochMilliseconds
//        self.xAxis.axisMinimum = nowEpochMilliseconds - Double(timeInterval)
        
        self.leftAxis.drawLabelsEnabled = true
        self.leftAxis.labelTextColor = lightGray
        self.leftAxis.labelFont = UIFont(name: "Helvetica", size: 18)!
        self.leftAxis.axisLineColor = UIColor.clear
        self.leftAxis.gridColor = lightGray
        self.leftAxis.labelCount = 6
        
        self.rightAxis.drawLabelsEnabled = false
        self.rightAxis.axisLineColor = UIColor.clear
        
        self.legend.enabled = false
        
        startAnimation()
        
    }
    
    func startAnimation() {
        if chartData.dataSets.count == 0 {
            return
        }
        
        self.animate(yAxisDuration: 1.0, easingOption: .easeInOutCirc)
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

