//
//  CollectionViewCell.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 10/18/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var cellLabel: UILabel!
    @IBOutlet weak var cellIcon: UIImageView!
    
    let labels = ["Temperature", "Humidity", "Dust", "Carbon Monoxide", "Methane"]
    var focusImage: UIImage?
    var unfocusImage: UIImage?
    var focusColor: UIColor?
    var unfocusColor = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0)
    var isFocus = false
    
    public func setupCell(type: Int) {
        cellLabel.text = labels[type]
        switch type {
        case 0:
            focusImage = #imageLiteral(resourceName: "Temp_Aceso")
            unfocusImage = #imageLiteral(resourceName: "Temp_Apag")
            focusColor = UIColor(red: 80/255, green: 201/255, blue: 246/255, alpha: 1.0)
            self.focus()
        case 1:
            focusImage = #imageLiteral(resourceName: "Humi_Aceso")
            unfocusImage = #imageLiteral(resourceName: "Humi_Apag")
            focusColor = UIColor(red: 88/255, green: 88/255, blue: 214/255, alpha: 1.0)
            isFocus = true
            self.unfocus()
        case 2:
            focusImage = #imageLiteral(resourceName: "Dust_Aceso")
            unfocusImage = #imageLiteral(resourceName: "Dust_Apag")
            focusColor = UIColor(red: 255/255, green: 149/255, blue: 0/255, alpha: 1.0)
            isFocus = true
            self.unfocus()
        case 3:
            focusImage = #imageLiteral(resourceName: "CO_Aceso")
            unfocusImage = #imageLiteral(resourceName: "CO_Apag")
            focusColor = UIColor(red: 76/255, green: 217/255, blue: 100/255, alpha: 1.0)
            isFocus = true
            self.unfocus()
        case 4:
            focusImage = #imageLiteral(resourceName: "Methane_Aceso")
            unfocusImage = #imageLiteral(resourceName: "Methane_Apag")
            focusColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            isFocus = true
            self.unfocus()
        default:
            break
        }
    }
    
    public func focus() {
        if isFocus == true {
            return
        }
        isFocus = true
        cellIcon.image = focusImage
        cellLabel.textColor = focusColor
        
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowRadius = 10.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: nil)
    }
    
    public func unfocus() {
        if isFocus == false {
            return
        }
        isFocus = false
        cellIcon.image = unfocusImage
        cellLabel.textColor = unfocusColor
        
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.7
        self.layer.shadowOffset = CGSize(width: 0, height: 10)
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveEaseIn, animations: {
            self.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }, completion: nil)
    
    }
    
}

