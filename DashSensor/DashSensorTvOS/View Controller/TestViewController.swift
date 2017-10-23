//
//  TestViewController.swift
//  DashSensor
//
//  Created by Andre Tsuyoshi Sakiyama on 10/17/17.
//  Copyright © 2017 Venturus. All rights reserved.
//

import UIKit

class TestViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

extension TestViewController: UICollectionViewDelegate {
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        let previousCell = context.previouslyFocusedView
        previousCell?.layer.borderWidth = 0.0
        previousCell?.layer.shadowRadius = 0.0
        previousCell?.layer.shadowOpacity = 0
        
        let nextCell = context.nextFocusedView
        nextCell?.layer.borderWidth = 8.0
        nextCell?.layer.borderColor = UIColor.black.cgColor
        nextCell?.layer.shadowColor = UIColor.black.cgColor
        nextCell?.layer.shadowRadius = 10.0
        nextCell?.layer.shadowOpacity = 0.9
        nextCell?.layer.shadowOffset = CGSize(width: 0, height: 0)

        
        
    }
    
}

extension TestViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "testCell", for: indexPath)
        
        return cell
        
    }
}
