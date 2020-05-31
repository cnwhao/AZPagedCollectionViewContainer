//
//  AZPagedCardFlowLayout.swift
//  AZCardCollectionFlowLayout
//
//  Created by William on 2020/5/29.
//  Copyright © 2020 whao. All rights reserved.
//

import UIKit

//MARK:-
public enum AZAlignment {
    case center
    case other
}
//MARK:- layout configuration
public struct AZPagedCardLayoutConfigue {
    public var alignment:AZAlignment = .center
    // scroll direction
    public var scrollDirection: UICollectionView.ScrollDirection = .vertical
    // card size
    public var cardSize:CGSize = CGSize(width: 300, height: 400)
    // margin between cards
    public var cardMargin: CGFloat = 10.0
    // scale card or not
    public var isScaleCard: Bool = true
    
    public init() {
        
    }
}

public class AZPagedCardFlowLayout: UICollectionViewFlowLayout {
    private(set) var config: AZPagedCardLayoutConfigue!
    init(configue:AZPagedCardLayoutConfigue=AZPagedCardLayoutConfigue()) {
        super.init()
        config = configue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepare() {
        self.scrollDirection = config.scrollDirection
        self.itemSize = config.cardSize
        self.minimumLineSpacing = config.cardMargin
    }
}
