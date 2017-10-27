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
    
}

extension MainViewController: UICollectionViewDelegate {

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
