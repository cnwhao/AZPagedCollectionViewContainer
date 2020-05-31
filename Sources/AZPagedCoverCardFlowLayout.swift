//
//  AZPagedCoverCardFlowLayout.swift
//  AZCardCollectionFlowLayout
//
//  Created by William on 2020/5/29.
//  Copyright © 2020 whao. All rights reserved.
//

import UIKit

class AZPagedCoverCardFlowLayout: AZPagedCardFlowLayout {
    override func prepare() {
        self.scrollDirection = config.scrollDirection
        self.itemSize = config.cardSize
        self.minimumLineSpacing = config.cardMargin
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let originalAttributesArr = super.layoutAttributesForElements(in: rect)
        // copy layout attributes
        var attributesArr: Array<UICollectionViewLayoutAttributes> = Array()
        for attr in originalAttributesArr! {
            attributesArr.append(attr.copy() as! UICollectionViewLayoutAttributes)
        }
        // screen center value , the value is offset x plus the widtn of collectionview, when scrollDirection is horizontal;
        var centerValue:CGFloat = 0
        // maximum moving distance, the calculation range is the distance before the card moves out of the screen
        var maxApart:CGFloat = 0
        if scrollDirection == .horizontal {
            centerValue = (self.collectionView?.contentOffset.x)!+(self.collectionView?.bounds.width)!/2
            maxApart = ((self.collectionView?.bounds.width)!+self.itemSize.width)/2
        } else {
            centerValue = (self.collectionView?.contentOffset.y)!+self.itemSize.height/2
            maxApart = ((self.collectionView?.bounds.height)!+self.itemSize.height)/2
        }
        
        // card中心位置调整、card缩放调整
        for attributes in attributesArr {
            //获取cell中心和屏幕中心的距离
            var apart:CGFloat = 0
            if scrollDirection == .horizontal {
                apart = attributes.center.x-centerValue
            } else {
                apart = attributes.center.y-centerValue
            }
            //移动进度 -1~1
            let progress = apart/maxApart
            attributes.zIndex = attributes.indexPath.row
            if apart <= 0 {
                if scrollDirection == .horizontal {
                    attributes.center = CGPoint(x: centerValue, y: attributes.center.y)
                } else {
                    attributes.center = CGPoint(x: attributes.center.x , y: centerValue)
                }
            }
            if config.isScaleCard == false {
                continue
            }
            //在屏幕外的cell不处理
            if progress >= 0 {
                continue
            }
            let scale = abs(cos(progress * CGFloat(Double.pi/10)))
            //缩放大小
            attributes.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
        return attributesArr
    }
     
    //是否实时刷新布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
