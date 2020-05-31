//
//  ViewController.swift
//  AZPagedCollectionViewContainer
//
//  Created by William on 2020/5/31.
//  Copyright © 2020 whao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private var cardCoverView:AZPagedCardView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        var config = AZPagedCardLayoutConfigue()
        config.alignment = .center
        
        cardCoverView = AZPagedCardView(configue: config)
        cardCoverView!.backgroundColor = .blue
        self.view.addSubview(cardCoverView!)
        var rect = self.view.bounds
        rect.origin.y = 100
        rect.size.height -= 200
        
        cardCoverView!.frame = rect
        
        cardCoverView!.delegate = self
        cardCoverView!.dataSource = self
        cardCoverView!.register(cellClass: UICollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "Cell")
    }
}

extension ViewController:AZPagedCardDataSource, AZPagedCardDelegate {
    func numberOfCards() -> Int {
        return 10
    }
    
    func cellForCardAtIndex(index: Int) -> UICollectionViewCell {
        let cell = cardCoverView!.dequeueReusableCell(withReuseIdentifier: "Cell", for: index)
        cell.backgroundColor = index % 2 == 0 ? .red : .yellow
        return cell
    }
}
