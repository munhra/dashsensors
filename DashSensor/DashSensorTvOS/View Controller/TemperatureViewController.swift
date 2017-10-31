//
//  TemperatureViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/25/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import ElasticSearchQuery
import Charts

class TemperatureViewController: DataViewController {
    
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var dateIntervalLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var highlightedDataLabel: UILabel!
    @IBOutlet weak var highlightedTextLabel: UILabel!
    @IBOutlet weak var customLineChartView: CustomLineChartView!
    
    override func handleData(avg: Int, max: Int, min: Int, dataArray: [Int], timestampArray: [Int], firstDataBeforeStart: Int) {
        super.reduceData(dataArray: dataArray, timestampArray: timestampArray, firstDataBeforeStart: firstDataBeforeStart)
        
        maxLabel.text = String(reducedMax) + "º C"
        minLabel.text = String(reducedMin) + "º C"
        if (timeIntervalIndex > 0) {
            highlightedDataLabel.text = String(avg) + "º C"
        }
        
        if timeIntervalIndex == 0 {
            customLineChartView.isHourFormat = true
        }
        customLineChartView.setData(dataArray: reducedDataArray, timestampArray: reducedTimestampArray, field: "Temperature", timeInterval: timeInterval[timeIntervalIndex], reducedTimeInterval: reducedTimeInterval[timeIntervalIndex])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupIntervalLabels()
        setupDataLabels()
        customLineChartView.themeColor = UIColor(red: 80/255, green: 201/255, blue: 246/255, alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        customLineChartView.startAnimation()
    }
    
    func registerSocketEvents() {
        socket?.on("sensorJSON") {data, ack in
            if let dataJSON = data as? [[String: Any]]  {
                if let temperature = dataJSON[0]["temperature"] as? Int {
                    self.highlightedDataLabel.text = String(temperature) + "º C"
                }
            }
        }
    }
    
    func setupIntervalLabels() {
        timeIntervalLabel.text = self.timeIntervalText[timeIntervalIndex]
        let minutesRange = timeInterval[timeIntervalIndex] / 60000
        let startDate = Calendar.current.date(byAdding: .minute, value: -minutesRange, to: dateNow)
        let endDate = dateNow
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM"
        let dateIntervalString = formatter.string(from: startDate!) + " - " + formatter.string(from: endDate)
        dateIntervalLabel.text = dateIntervalString
    }
    
    func setupDataLabels() {
        if (timeIntervalIndex == 0) {
            self.highlightedTextLabel.text = "Currently"
            self.registerSocketEvents()
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

