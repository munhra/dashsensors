//
//  MethaneViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/25/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import ElasticSearchQuery
import Charts

class MethaneViewController: DataViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var highlightedDataLabel: UILabel!
    @IBOutlet weak var highlightedTextLabel: UILabel!
    @IBOutlet weak var customLineChartView: CustomLineChartView!
    
    override func handleData(avg: Int, max: Int, min: Int, dataArray: [Int], timestampArray: [Int], firstDataBeforeStart: Int) {
        super.reduceData(dataArray: dataArray, timestampArray: timestampArray)
        
        maxLabel.text = String(reducedMax)
        minLabel.text = String(reducedMin)
        if (timeIntervalIndex > 0) {
            highlightedDataLabel.text = String(avg)
        } else if reducedDataArray.count == 0 {
            highlightedDataLabel.text = "0"
        } else {
            highlightedDataLabel.text = String(describing: reducedDataArray.last!)
        }
        
//        if timeIntervalIndex == 0 {
//            customLineChartView.isHourFormat = true
//        }
        customLineChartView.setData(dataArray: reducedDataArray, timestampArray: reducedTimestampArray, field: "Methane", timeInterval: timeInterval[timeIntervalIndex])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupIntervalLabels()
        setupDataLabels()
        customLineChartView.themeColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customLineChartView.startAnimation()
    }
    
    func setupIntervalLabels() {
        timeIntervalLabel.text = self.timeIntervalText[timeIntervalIndex]
        let minutesRange = timeInterval[timeIntervalIndex] / 60000
        let startDate = Calendar.current.date(byAdding: .minute, value: -minutesRange, to: Date())
        let endDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        let dateIntervalString = formatter.string(from: startDate!) + " - " + formatter.string(from: endDate)
        dateIntervalLabel.text = dateIntervalString
    }
    
    func setupDataLabels() {
        if (timeIntervalIndex == 0) {
            self.highlightedTextLabel.text = "Currently"
        } else {
            self.highlightedTextLabel.text = "Average"
        }
    }

    func setupCardView() {
        cardView.layer.shadowColor = UIColor.lightGray.cgColor
        cardView.layer.shadowRadius = 5.0
        cardView.layer.shadowOpacity = 0.7
        cardView.layer.shadowOffset = CGSize(width: 0, height: 10)
    }
    
}
