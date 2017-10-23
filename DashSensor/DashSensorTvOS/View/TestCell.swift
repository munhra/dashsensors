//
//  TestCell.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 10/17/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit

class TestCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if (selected) {
        }
        // Configure the view for the selected state
    }
    
//    var color: UIColor = .white {
//        didSet {
//            updateBackgroundColor()
//        }
//    }
//
//    func updateBackgroundColor() {
//        if isFocused {
//            contentView.backgroundColor = color
//        } else {
//            contentView.backgroundColor = color.withAlphaComponent(0.25)
//        }
//    }
//
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        coordinator.addCoordinatedAnimations({ () -> Void in
//            self.updateBackgroundColor()
//        }, completion: nil)
//    }

}
