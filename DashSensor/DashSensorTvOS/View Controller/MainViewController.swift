//
//  MainViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 10/17/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let dataTypes = ["temperature", "dust", "humidity", "methane", "co"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerView: UIView!
    var pageViewController: PageViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        highlightCell(index: 0)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ContainerSegue" {
            pageViewController = segue.destination as? PageViewController
            pageViewController?.mainViewController = self
        }
    }
    
    public func highlightCell(index: Int) {
        for i in 0..<dataTypes.count {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0)) as! CollectionViewCell
            
            if index != i {
                cell.unfocus()
            } else {
                cell.focus()
            }
        }

    }
//        if previousRow != nil {
//            let previousCell = collectionView.cellForItem(at: IndexPath(item: previousRow!, section: 0))
//            previousCell?.backgroundColor = UIColor.white
////            previousCell?.layer.borderWidth = 0.0
////            previousCell?.layer.shadowRadius = 0.0
////            previousCell?.layer.shadowOpacity = 0
//        }
//
//        let nextCell = collectionView.cellForItem(at: IndexPath(item: nextRow, section: 0))
//        nextCell?.backgroundColor = UIColor.cyan
////        nextCell?.layer.borderWidth = 8.0
////        nextCell?.layer.borderColor = UIColor.black.cgColor
////        nextCell?.layer.shadowColor = UIColor.black.cgColor
////        nextCell?.layer.shadowRadius = 10.0
////        nextCell?.layer.shadowOpacity = 0.9
////        nextCell?.layer.shadowOffset = CGSize(width: 0, height: 0)
//    }
    

}

extension MainViewController: UICollectionViewDelegate {
//    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
//        let previousFocusedCell = context.previouslyFocusedView as? CollectionViewCell
//        if previousFocusedCell != nil {
//            previousFocusedCell?.unfocus()
//        }
//
//        let nextFocusedCell = context.nextFocusedView as! CollectionViewCell
//        nextFocusedCell.focus()
//    }
}

extension MainViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCell", for: indexPath) as! CollectionViewCell
        cell.setupCell(type: indexPath.row)
        
        return cell
        
    }
}
