//
//  DustViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/22/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import ElasticSearchQuery
import Charts

class DustViewController: DataViewController {
    
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var customLineChartView: CustomLineChartView!
    
    override func handleData(avg: Int, max: Int, min: Int, dataArray: [Int], timestampArray: [Int]) {
        avgLabel.text = "Average: " + String(avg)
        maxLabel.text = "Maximum: " + String(max)
        minLabel.text = "Minimum: " + String(min)
        
        if timeIntervalIndex == 0 {
            customLineChartView.isHourFormat = true
        }
        customLineChartView.setData(dataArray: dataArray, timestampArray: timestampArray, field: "Dust")
        
        self.view.layoutIfNeeded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customLineChartView.startAnimation()
    }

}

