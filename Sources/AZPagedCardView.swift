//
//  AZPagedCardView.swift
//  AZCardCollectionFlowLayout
//
//  Created by William on 2020/5/29.
//  Copyright © 2020 whao. All rights reserved.
//

import UIKit

//MARK:- collectionView data source
@objc public protocol AZPagedCardDataSource {
    // number of cards
    func numberOfCards() -> Int
    // card at index
    func cellForCardAtIndex(index: Int) -> UICollectionViewCell
}
//MARK:- collectionView delegate
@objc public protocol AZPagedCardDelegate: NSObjectProtocol {
    // optional, card is scrolling
    @objc optional func cardDidScroll(scrollView: UIScrollView)
    // optional, card scrollview to target index
    @objc optional func cardDidScrollToIndex(index: Int)
    // optional, selected card of index
    @objc optional func cardDidSelectedAtIndex(index: Int)
}

public class AZPagedCardView: UIView {
    public weak var delegate: AZPagedCardDelegate?
    public weak var dataSource: AZPagedCardDataSource?
    
    // content offset x when begin dragging collectionview
    private var dragStartX: CGFloat = 0
    // content offset x when ended dragging collectionview
    private var dragEndX: CGFloat = 0
    // number of index being dragged
    private var dragAtIndex: Int = 0
    // content offset y when begin dragging collectionview
    private var dragStartY: CGFloat = 0
    // content offset y when ended dragging collectionview
    private var dragEndY: CGFloat = 0
    
    private var selectedIndex: Int = 0
    
    private let flowlayout:AZPagedCardFlowLayout!
    private(set) lazy var collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: flowlayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.clear
//        if flowlayout.config.scrollDirection == .horizontal {
//            view.showsHorizontalScrollIndicator = false
//        } else {
//            view.showsVerticalScrollIndicator = false
//        }
        return view
    }()
    
    public init(configue:AZPagedCardLayoutConfigue = AZPagedCardLayoutConfigue()) {
        if configue.alignment == .other {
            flowlayout = AZPagedCoverCardFlowLayout(configue: configue)
        } else {
            flowlayout = AZPagedCardFlowLayout(configue: configue)
        }
        super.init(frame: .zero)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if collectionView.bounds == .zero {
            collectionView.frame = bounds
            
            if flowlayout.config.scrollDirection == .horizontal {
                var offsetX = collectionView.frame.size.width - flowlayout.config.cardSize.width
                offsetX = offsetX > 0 ? offsetX : 0
                if flowlayout.config.alignment == .center {
                    collectionView.contentInset = UIEdgeInsets(top: 0, left: offsetX * 0.5, bottom: 0, right: offsetX * 0.5)
                } else {
                    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: offsetX > 0 ? offsetX : 0)
                }
            } else {
                var offsetY = collectionView.frame.size.height - flowlayout.config.cardSize.height
                offsetY = offsetY > 0 ? offsetY : 0
                if flowlayout.config.alignment == .center {
                    collectionView.contentInset = UIEdgeInsets(top: offsetY * 0.5, left: 0, bottom: offsetY * 0.5, right: 0)
                } else {
                    collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: offsetY, right: 0)
                }
            }
        }
    }
    private func setUpSubviews() {
        addSubview(collectionView)
    }
}

extension AZPagedCardView {
    //MARK:-public functions
    open func register(cellClass: AnyClass?, forCellWithReuseIdentifier identifier: String) {
        collectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    open func dequeueReusableCell(withReuseIdentifier identifier: String, for index: Int) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: IndexPath(row: index, section: 0))
    }
    
    //MARK:-private functions
    // adjust card
    @objc private func fixCellToCenter() {
        if selectedIndex != dragAtIndex {
            scrollToCenterAnimated(animated: true)
            return
        }
        // minimum dragging distance to trigger pagination
        let dragMiniDistance = bounds.width/10
        if flowlayout.config.scrollDirection == .horizontal {
            if dragStartX - dragEndX >= dragMiniDistance {
                selectedIndex -= 1 // towards left
            } else if dragEndX - dragStartX >= dragMiniDistance {
                selectedIndex += 1 // towards right
            }
        } else {
            if dragStartY - dragEndY >= dragMiniDistance {
                selectedIndex -= 1 // towards up
            } else if dragEndY - dragStartY >= dragMiniDistance {
                selectedIndex += 1 // towards down
            }
        }
        let maxIndex = collectionView.numberOfItems(inSection: 0) - 1
        // make sure index in bounds
        selectedIndex = max(selectedIndex, 0)
        selectedIndex = min(selectedIndex, maxIndex)
        
        scrollToCenterAnimated(animated: true)
        delegateUpdateScrollIndex(index: selectedIndex)
    }
    
    /// scrolling card center to screen center
    /// - Parameter animated: is animated
    private func scrollToCenterAnimated(animated: Bool) {
        DispatchQueue.main.async {
            if self.flowlayout.config.scrollDirection == .horizontal {
                self.collectionView.setContentOffset(CGPoint(x: CGFloat(self.selectedIndex) * (self.flowlayout.config.cardSize.width + self.flowlayout.config.cardMargin) - self.collectionView.contentInset.left, y: 0), animated: true)
            } else {
                self.collectionView.setContentOffset(CGPoint(x: 0, y: CGFloat(self.selectedIndex) * (self.flowlayout.config.cardSize.height + self.flowlayout.config.cardMargin) - self.collectionView.contentInset.top), animated: true)
            }
        }
    }
    
    private func delegateUpdateScrollIndex(index: Int) {
        guard let delegate = delegate else {
            return
        }
        if (delegate.responds(to: #selector(delegate.cardDidScrollToIndex(index:)))) {
            delegate.cardDidScrollToIndex?(index: index)
        }
    }
    
    private func delegateSelectedAtIndex(index: Int) {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(delegate.cardDidSelectedAtIndex(index:))) {
            delegate.cardDidSelectedAtIndex?(index: index)
        }
    }
}

extension AZPagedCardView:UICollectionViewDataSource {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfCards() ?? 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return (dataSource?.cellForCardAtIndex(index: indexPath.row))!
    }
}

extension AZPagedCardView:UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        scrollToCenterAnimated(animated: true)
        delegateSelectedAtIndex(index: indexPath.row)
        delegateUpdateScrollIndex(index: selectedIndex)
    }
}

extension AZPagedCardView:UIScrollViewDelegate {
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if flowlayout.config.scrollDirection == .horizontal {
            dragStartX = scrollView.contentOffset.x
        } else {
            dragStartY = scrollView.contentOffset.y
        }
        dragAtIndex = selectedIndex
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if flowlayout.config.scrollDirection == .horizontal {
            dragEndX = scrollView.contentOffset.x
        } else {
           dragEndY = scrollView.contentOffset.y
        }
        fixCellToCenter()
    }
    
    public func scrollViewDidScrollToTop(_ scrollView: UIScrollView) {
        selectedIndex = 0
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let delegate = delegate else {
            return
        }
        if delegate.responds(to: #selector(delegate.cardDidScroll(scrollView:))) {
            delegate.cardDidScroll?(scrollView: scrollView)
        }
    }
}
