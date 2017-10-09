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
    let timeInterval = [86400000, 604800000, 1209600000, 2629743000]
    var timeIntervalIndex = 0
    var dataType = ""
    var socket : SocketIOClient?
    
    func handleData(avg: Int, max: Int, min: Int, dataArray: [Int], timestampArray: [Int]) {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let epochNow = Int(ceil(Date().timeIntervalSince1970 * 1000))
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
        self.view.layoutIfNeeded()
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


