//
//  SLScrollSameDistanceFlowLayout.swift
//  SLCollectionViewTest
//
//  Created by X.T.X on 2018/2/24.
//  Copyright © 2018年 shiliukeji. All rights reserved.
//

import UIKit

/*
 每次水平滑动固定距离的UICollectionView
 用法:let collectView = UICollectionView(frame: view.bounds, collectionViewLayout: SLScrollSameDistanceFlowLayout())
 */
class SLScrollSameDistanceFlowLayout: UICollectionViewFlowLayout {
    
    /// 准备
    override func prepare() {
        super.prepare()
        scrollDirection = .horizontal
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.decelerationRate = 0.99 // 滚动速度,越小停的越快,默认0.998
    }
    
    /// 每次滑动会调用此方法
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        guard let collectionView = collectionView else {
            return proposedContentOffset
        }

        var rect = CGRect()
        rect.origin = proposedContentOffset
        rect.size = collectionView.frame.size
        
        guard let array = layoutAttributesForElements(in: rect) else {
            return proposedContentOffset
        }

        let centerX = proposedContentOffset.x + collectionView.frame.width/2
        
        var adjustOffsetX = MAXFLOAT
        for attrs in array {
            if fabsf(Float(attrs.center.x - centerX)) <= fabsf(adjustOffsetX) {
                adjustOffsetX = Float(attrs.center.x - centerX)
            }
        }

        return CGPoint(x: proposedContentOffset.x + CGFloat(adjustOffsetX), y: proposedContentOffset.y)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
