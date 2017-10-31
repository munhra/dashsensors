//
//  DataViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 9/25/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit
import ElasticSearchQuery
import Charts
import SocketIO

class DataViewController: UIViewController {
    let timeIntervalText = ["Daily", "Weekly", "Monthly", "Quarterly"]
    let timeInterval = [86400000, 604800000, 2592000000, 7776000000]
    var reducedTimeInterval = [3600000, 21600000, 86400000, 172800000]
//    let timeIntervalText = ["Last Month", "2 Months Ago", "3 Months Ago"]
//    let timeInterval = [2629743000, 5259486000, 7889229000]
    var dateNow = Date()
    var nSlices = 20
    
    var reducedDataArray: [Int] = []
    var reducedTimestampArray: [Int] = []
    var reducedMax = 0
    var reducedMin = 0
    var timeIntervalIndex = 0
    var dataType = ""
    var socket : SocketIOClient?
    
    func handleData(avg: Int, max: Int, min: Int, dataArray: [Int], timestampArray: [Int], firstDataBeforeStart: Int) {

    }
    
    func reduceData(dataArray: [Int], timestampArray: [Int], firstDataBeforeStart: Int) {
        var lastData = firstDataBeforeStart
        var datePointer = Int(ceil(self.dateNow.timeIntervalSince1970 * 1000)) - timeInterval[timeIntervalIndex]
        var i = 0
        
        while datePointer <= Int(dateNow.timeIntervalSince1970 * 1000) {
            var dataSegment = 0
            var segmentSize  = 0
            if timestampArray.count > 0 {
                while i < timestampArray.count && timestampArray[i] < datePointer {
                    dataSegment += dataArray[i]
                    i += 1
                    segmentSize += 1
                }
            }
            
            if (segmentSize == 0) {
                dataSegment = lastData
            } else {
                dataSegment /= segmentSize
                lastData = dataSegment
            }
            
            self.reducedDataArray.append(dataSegment)
            self.reducedTimestampArray.append(datePointer)
            
            datePointer += reducedTimeInterval[timeIntervalIndex]
        }
        
        if reducedDataArray.count > 0 {
            reducedMin = reducedDataArray.min()!
            reducedMax = reducedDataArray.max()!
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let epochNow = Int(ceil(self.dateNow.timeIntervalSince1970 * 1000))
        let epochPastString = String(epochNow - timeInterval[timeIntervalIndex])
        let epochNowString = String(epochNow)

        ElasticSearchQuery.setURL(url: "https://search-fti-es-szgjq3dzpsev2nkngqfamoegiu.us-west-2.es.amazonaws.com/iot_fti2/_search?")
        
        switch self.dataType {
        case "dust":
            ElasticSearchQuery.getDust(from: epochPastString, to: epochNowString, callback: handleData)
        case "humidity":
            ElasticSearchQuery.getHumidity(from: epochPastString, to: epochNowString, callback: handleData)
        case "temperature":
            ElasticSearchQuery.getTemperature(from: epochPastString, to: epochNowString, callback: handleData)
        case "methane":
            ElasticSearchQuery.getMethane(from: epochPastString, to: epochNowString, callback: handleData)
        case "co":
            ElasticSearchQuery.getCO(from: epochPastString, to: epochNowString, callback: handleData)
        default:
            return
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}


