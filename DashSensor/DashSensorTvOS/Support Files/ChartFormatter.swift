//
//  ChartFormatter.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/25/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import Charts

class ChartFormatter: NSObject, IAxisValueFormatter{
    var timestampArray = [Int]()
    let dateFormatter = DateFormatter()
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(value / 1000))
        
        return String(dateFormatter.string(from: date))
    }
    
    public func setValue(values: [Int]) {
        self.timestampArray = values
    }
}
